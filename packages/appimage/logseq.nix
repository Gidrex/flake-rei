{ 
  lib, 
  appimageTools, 
  fetchurl,
}:

let
  version = "0.10.10-alpha+nightly.20241015";
  pname = "logseq";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/nightly/Logseq-linux-x64-${version}.AppImage";
    hash = "sha256-b00652839705d3a928874f0a4f68fd2b404bb225d8d8e59936c54770340e5ff2";
  };

  appimageContents = appimageTools.extractType1 { inherit name src; };
in
appimageTools.wrapType1 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Logseq, open-source outliner for knowledge management and collaboration";
    homepage = "https://logseq.com/";
    downloadPage = "https://github.com/logseq/logseq/releases";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ idk ];
    platforms = [ "x86_64-linux" ];
  };
}
