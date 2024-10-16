{ lib, appimageTools, fetchurl, ... }:

let
  version = "0.10.10-alpha+nightly.20241015";
  pname = "logseq";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/nightly/Logseq-linux-x64-${version}.AppImage";
    hash = "sha256-sAZSg5cF06koh08KT2j9K0BLsiXY2OWZNsVHcDQOX/I=";
  };

  appimageContents = appimageTools.extractType1 { inherit name src; };
in
  {
  appimageTools.wrapType1 {
  inherit name src;

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
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
}
