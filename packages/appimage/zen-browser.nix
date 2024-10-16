{ lib, appimageTools, fetchurl, ... }:

let
  version = "1.0.1-a.10";
  pname = "zen-generic";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/${pname}.AppImage";
    hash = "sha256-rvMDVDXEpsZk1CDMhS8b8QiM2hTYFMmkKt/uEk76Xrc=";
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
