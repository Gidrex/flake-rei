{ pkgs, ... }: 
{
  programs.starship.enableFishIntegration = false;
  programs.zellij.enableFishIntegration = false;
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
        interactiveShellInit = ''
          set -U fifc_exa_opts  --oneline --icons --git --tree --level 2
          '';
      }
    ];

    shellAliases = {
      "!!" = "eval sudo (history | head -n1 | string trim)";
      ls = "eza";
      la = "ls -al --no-user";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      grep = "rg";
      rr = "ranger";
      yz = "yazi";
      rb = "~/flake-rei/backup.sh && sudo nixos-rebuild switch --upgrade-all --flake ~/flake-rei";
      rbn = "sudo nixos-rebuild switch --upgrade-all --flake ~/flake-rei";
      nv = "nvim";
      tx = "tmux";
      zl = "zellij";
      nf = "nvim $(fzf)";
      lights = "sudo chmod a+wr /sys/class/backlight/intel_backlight/brightness"; # yea, Im stupid, questions?
      trans = "crow -s en -t ru -e yandex -b";
      calc = "~/github/calc.rs/clc/wrapper.sh";
    };

    interactiveShellInit = ''
      function fish_greeting
      end

      set -Ux fifc_editor nvim
      set -U fifc_keybinding \cx
    '';
  };
}
