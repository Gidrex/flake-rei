{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  fetchandroid = callPackage ./fetch.nix { };
  mkGeneric = callPackage ./generic.nix { };
  mkBuildTools = callPackage ./build-tools.nix { };
  mkCmdlineTools = callPackage ./cmdline-tools.nix { };
  mkEmulator = callPackage ./emulator.nix { };
  mkNdk = callPackage ./ndk.nix { };
  mkNdkBundle = callPackage ./ndk-bundle.nix { };
  mkPlatformTools = callPackage ./platform-tools.nix { };
  mkPrebuilt = callPackage ./prebuilt.nix { };
  mkSrcOnly = callPackage ./src-only.nix { };
  mkTools = callPackage ./tools.nix { };
})
