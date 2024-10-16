{ lib, appimageTools, fetchurl, ... }:

let
  version = "0.10.10-alpha+nightly.20241015";
  pname = "zen-generic";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/${pname}.AppImage";
    hash = "sha256-sAZSg5cF06koh08KT2j9K0BLsiXY2OWZNsVHcDQOX/I=";
  };

  appimageContents = appimageTools.extractType1 { inherit name src; };
in
  appimageTools.wrapType1 {
    inherit name src;

    extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    meta = {
      description = "Beautifully designed, privacy-focused, and packed with features.";
      homepage = "https://zen-browser.app/";
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [ mauro-balades BrhmDev kristijanribaric ];
      platforms = [ "x86_64-linux" ];
    };
  }
