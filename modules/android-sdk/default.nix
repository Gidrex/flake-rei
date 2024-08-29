{ config, pkgs, ... }:

let
  androidSdkRoot = "$HOME/Android/Sdk";
in
{
  home.sessionVariables = {
    ANDROID_SDK_ROOT = androidSdkRoot;
    ANDROID_HOME = androidSdkRoot;
    PATH = "${androidSdkRoot}/cmdline-tools/latest/bin:${androidSdkRoot}/platform-tools:${config.home.sessionVariables.PATH}";
  };
}
