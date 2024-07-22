{ pkgs, ... }: 
{
  programs.starship.enableFishIntegration = false;
  programs.enableFishIntegration = false;
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "fifc";
        src = pkgs.fishPlugins.fifc.src;
      }
    ];

    shellAliases = {
      "!!" = "eval sudo (history | head -n1 | string trim)";
      ls = "eza";
      la = "ls -al --no-user";
      cat = "bat";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      grep = "rg";
      rr = "ranger";
      yz = "yazi";
      rb = "~/flake-rei/backup.sh && sudo nixos-rebuild switch --upgrade-all --flake ~/flake-rei";
      rbn = "sudo nixos-rebuild switch --upgrade-all --flake ~/flake-rei";
      nv = "nvim";
      tx = "tmux";
      nf = "nvim $(fzf)";
      fk = "fuck";
      lights = "sudo chmod a+wr /sys/class/backlight/intel_backlight/brightness"; # yea, Im stupid, questions?
      trans = "crow -s en -t ru -e yandex -b";
    };

    interactiveShellInit = ''
      function fish_greeting
      end

      set -Ux fifc_editor nvim
      set -U fifc_keybinding \cx
    '';
  };
}
