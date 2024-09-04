{ pkgs, ... }: 
{
  programs = {
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
        nv = "nvim";
        nf = "nvim $(fzf)";
        lights = "sudo chmod a+wr /sys/class/backlight/intel_backlight/brightness"; # yea, Im stupid, questions?
        trans = "crow -s en -t ru -e yandex -b";
        calc = "~/github/calc.rs/wrapper.sh";

        # zellij
        zl = "zellij";
        zla = "zellij attach";
        zln = "zellij --session";
      };

      interactiveShellInit = ''
      function fish_greeting
      end

      set -x http_proxy http://127.0.0.1:8889
      set -x https_proxy http://127.0.0.1:8889
      set -x all_proxy socks5://localhost:1089
      set -x no_proxy localhost,127.0.0.1,::1

      set -Ux fifc_editor nvim
      set -U fifc_exa_opts  --oneline --icons --git --tree --level 2
      '';

      shellInit = ''
      fifc \
        -n test -f "$fifc_candidate" \
        -p _fifc_preview_file \
        -o _fifc_open_file

        -r '^(pacman|paru)(\\h*\\-S)?\\h+' \
        -s "pacman --color=always -Ss "$fifc_token" | string match -r \'^[^\\h+].*\'" \
        -e '.*/(.*?)\\h.*' \
        -p 'pacman -Si "$fifc_extracted"'
      '';
    };
  };
}
