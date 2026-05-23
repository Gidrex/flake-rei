{ pkgs, sshPublicKey, ... }:
{
  programs = {
    gpg.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  home.file = {
    ".ssh/id_ed25519.pub".text = sshPublicKey;
  };
}
