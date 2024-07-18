package codes.tad.nixandroidrepo

import com.android.prefs.AndroidLocationsSingleton
import com.android.repository.api.Channel
import com.android.repository.api.Checksum
import com.android.repository.api.Downloader
import com.android.repository.api.ProgressIndicator
import com.android.repository.api.ProgressIndicatorAdapter
import com.android.repository.api.RemotePackage
import com.android.repository.api.Repository
import com.android.repository.api.RepositorySource
import com.android.repository.api.SettingsController
import com.android.repository.impl.meta.LocalPackageImpl
import com.android.repository.impl.meta.RemotePackageImpl
import com.android.repository.impl.meta.SchemaModuleUtil
import com.android.sdklib.repository.AndroidSdkHandler
import com.android.sdklib.repository.legacy.LegacyRemoteRepoLoader
import com.android.sdklib.tool.sdkmanager.SdkManagerCli
import java.io.ByteArrayOutputStream
import java.io.FileNotFoundException
import java.io.InputStream
import java.io.PrintStream
import java.net.URL
import java.nio.file.Path
import kotlin.io.path.exists
import kotlin.io.path.fileSize
import kotlin.io.path.inputStream
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

class NixDownloader : Downloader {
    override fun downloadFully(url: URL, indicator: ProgressIndicator): Path {
        val target = kotlin.io.path.createTempFile("NixDownloader")
        downloadFully(url, target, null, indicator)
        return target
    }

    override fun downloadFully(
        url: URL,
        target: Path,
        checksum: Checksum?,
        indicator: ProgressIndicator
    ) {
        if (target.exists() && checksum != null) {
            indicator.setText("Verifying previous download...")
            target.inputStream().buffered().use { stream ->
                if (checksum.value == Downloader.hash(
                        stream,
                        target.fileSize(),
                        checksum.type,
                        indicator.createSubProgress(0.3)
                    )) {
                    return
                }
            }
        }
        println("Should download: $url -> $target")
    }

    override fun downloadAndStream(url: URL, indicator: ProgressIndicator): InputStream {
        return openUrl(url.toString())
    }

    private fun openUrl(
        url: String,
    ): InputStream {
        val connection = URL(url).openConnection()
        connection.connect()
        return connection.getInputStream().ensureMarkReset()
    }

    private fun InputStream.ensureMarkReset(): InputStream {
        return if (!markSupported()) {
            try {
                readBytes().inputStream().also {
                    try { close() } catch (_: Exception) {}
                }
            } catch (e: Exception) {
                this
            }
        } else {
            this
        }
    }
}

object NixProgressIndicator : ProgressIndicatorAdapter() {
    private var err: PrintStream = System.err

    override fun logWarning(s: String, e: Throwable?) {
        err.println("Warning: %s")
        e?.let { err.println(it.message) }
    }

    override fun logWarning(s: String) {
        logWarning(s, null)
    }

    override fun logError(s: String, e: Throwable?) {
        err.println("Error: %s")
        e?.let { err.println(it.message) }
        throw SdkManagerCli.UncheckedCommandFailedException()
    }

    override fun logError(s: String) {
        logError(s, null)
    }
}

class NixSettings(
    private val channelId: Int
) : SettingsController {
    override fun getForceHttp(): Boolean = false

    override fun setForceHttp(force: Boolean) {}

    override fun getChannel(): Channel = Channel.create(channelId)
}

class NixRepoManager(
    channelId: Int
) {
    private val progress = NixProgressIndicator
    private val sdk = AndroidSdkHandler.getInstance(AndroidLocationsSingleton, null)
    private val repoManager = sdk.getSdkManager(progress)
    private val settings = NixSettings(channelId)
    private val downloader = NixDownloader()
    private val fallbackLoader = LegacyRemoteRepoLoader()

    fun getPackages(): Map<String, RemotePackage> {
        val parsedPackages = mutableMapOf<RepositorySource, Collection<RemotePackage>>()
        val legacyParsedPackages = mutableMapOf<RepositorySource, Collection<RemotePackage>>()

        val sources = repoManager.getSources(downloader, progress, true)

        runBlocking {
            for (source in sources) {
                launch(Dispatchers.IO) {
                    try {
                        val manifest = downloader.downloadAndStream(URL(source.url), progress)
                        parseSource(source, manifest, parsedPackages, legacyParsedPackages)
                    } catch (e: FileNotFoundException) {
                        progress.logWarning("Not found: ${source.url}")
                    }
                }
            }
        }

        val channel = settings.channel
        val packages = mutableMapOf<String, RemotePackage>()

        for ((source, sourcePackages) in parsedPackages) {
            mergePackages(channel, source, sourcePackages, packages)
        }
        for ((source, sourcePackages) in legacyParsedPackages) {
            mergePackages(channel, source, sourcePackages, packages)
        }

        return packages
    }

    private fun parseSource(
        source: RepositorySource,
        manifest: InputStream,
        result: MutableMap<RepositorySource, Collection<RemotePackage>>,
        legacyResult: MutableMap<RepositorySource, Collection<RemotePackage>>
    ) {
        val repo = SchemaModuleUtil.unmarshal(
            manifest,
            source.permittedModules,
            true,
            progress,
            source.url
        ) as? Repository
        if (repo != null) {
            result[source] = repo.remotePackage
        } else {
            legacyResult[source] = fallbackLoader.parseLegacyXml(source, downloader, settings, progress)
        }
    }

    private fun mergePackages(
        channel: Channel,
        source: RepositorySource,
        packages: Collection<RemotePackage>,
        result: MutableMap<String, RemotePackage>
    ) {
        for (pkg in packages) {
            pkg as RemotePackageImpl
            val existing = result[pkg.path]
            if (existing != null) {
                if (existing.version > pkg.version) continue

                if (existing.version < pkg.version) {
                    pkg.source = source
                    result[pkg.path] = pkg
                } else {
                    existing as RemotePackageImpl
                    val existingArchives = existing.allArchives
                    for (archive in pkg.allArchives) {
                        if (existingArchives.none { it.platform() == archive.platform() }) {
                            existing.addArchive(archive)
                        }
                    }
                }
            } else if (pkg.channel <= channel) {
                pkg.source = source
                result[pkg.path] = pkg
            }
        }
    }

    fun packageXml(pkg: RemotePackage): String {
        val factory = pkg.createFactory()
        val repo = factory.createRepositoryType()
        pkg.license?.let { repo.addLicense(it) }
        val impl = LocalPackageImpl.create(pkg)
        repo.setLocalPackage(impl)
        val element = factory.generateRepository(repo)
        return ByteArrayOutputStream().use { out ->
            SchemaModuleUtil.marshal(element, repoManager.schemaModules, out,
                repoManager.getResourceResolver(progress), progress)
            out.toString(Charsets.UTF_8.name())
        }
    }
}
