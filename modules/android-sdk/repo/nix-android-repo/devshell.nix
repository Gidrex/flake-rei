{ lib
, stdenv
, devshellPkgs
, gradle
, gradle-properties
, jdk
, update-locks
}:

with lib;

devshellPkgs.mkShell {
  name = "android-nixpkgs";

  env = [
    {
      name = "JAVA_HOME";
      eval = "${jdk.home}";
    }
  ];

  packages = [
    gradle
    jdk
  ];

  devshell.startup = {
    gradle-properties.text = ''
      rm -f $PRJ_ROOT/gradle.properties
      ln -sf ${gradle-properties} $PRJ_ROOT/gradle.properties
    '';
  };

  commands = [
    {
      name = "update-locks";
      help = "Update dependency lockfiles.";
      category = "development";
      package = update-locks;
    }
  ];
}
