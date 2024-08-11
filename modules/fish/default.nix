{ pkgs, ... }: 
{
  programs= {
    starship.enableFishIntegration = false;
    zellij.enableFishIntegration = false;
    zoxide.enableFishIntegration = true;
    fish = {
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
        {
          name = "fzf-fish";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];

      shellAliases = {
        "!!" = "eval sudo (history | head -n1 | string trim)";
        ls = "eza";
        la = "ls -al --no-user";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        grep = "rg";
        yz = "yazi";
        rb = "~/flake-rei/backup.sh && sudo nixos-rebuild switch --upgrade-all --flake ~/flake-rei";
        rbn = "sudo nixos-rebuild switch --upgrade-all --flake ~/flake-rei";
        tx = "tmux";
        nf = "nvim $(fzf)";
        lights = "sudo chmod a+wr /sys/class/backlight/intel_backlight/brightness"; # yea, Im stupid, questions?
        trans = "crow -s en -t ru -e yandex -b";
        calc = "~/github/calc.rs/clc/wrapper.sh";

        # zellij
        zl = "zellij";
        zla = "zellij attach";
        zln = "zellij --session";
      };

      interactiveShellInit = ''
      function fish_greeting
      end

      set -Ux fifc_editor nvim
      set -U fifc_exa_opts  --oneline --icons --git --tree --level 2
      set -U fifc_keybinding \cx
      '';

      functions.nv = ''
        function nv
          if test (count $argv) -eq 0
            set -l file (fzf)
            if test -n "$file"
              nvim "$file"
            end
          else
            nvim $argv
          end
        end
      '';
    };
  };
}
