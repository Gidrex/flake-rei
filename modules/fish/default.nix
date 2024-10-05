{ pkgs, ... }: 
{
  programs = {
    starship.enableFishIntegration = false;
    zellij.enableFishIntegration = false;
    zoxide.enableFishIntegration = true;
    yazi.enableFishIntegration = true;
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
        "....." = "cd ../../../../";
        grep = "rg";
        rb = "~/flake-rei/backup.sh && sudo nixos-rebuild switch --upgrade-all --flake ~/flake-rei";
        rbn = "sudo nixos-rebuild switch --upgrade-all --flake ~/flake-rei";
        tx = "tmux";
        nv = "nvim";
        suvi = "sudo nvim";
        trans = "crow -s en -t ru -e yandex -b";
        nix-shell-init = "touch default.nix && echo '{ pkgs ? import <nixpkgs> {} }:' > default.nix && echo '' >> default.nix && echo 'pkgs.mkShell {' >> default.nix && echo '  buildInputs = with pkgs; [' >> default.nix && echo '    # add your own packets' >> default.nix && echo '  ];' >> default.nix && echo '}' >> default.nix";
        wine-ru = "LANG=ru_RU.UTF-8 LC_ALL=ru_RU.UTF-8 wine '$@'";
        copy = "xclip -selection clipboard";
        fetch = ''echo -e "
          screenfetch 2>/dev/null
          fastfetch
          ghfetch -u Gidrex -c magenta --access-token $(pass show github_token)
        " | fzf | sh'';
        browser = "io.github.zen_browser.zen";

        # custom fzf scripts
        nf = ''nvim $(find . -type f | fzf --preview "bat {}" --preview-window=right:50%:wrap)'';
        nz = "search_files";
        zz = ''z $(find . -type d | fzf --preview "eza --icons=always {}" --preview-window=right:30%:wrap --exact)'';
        zx = ''z $(zoxide query -l | fzf --preview "eza -T --level 2 --icons=always {}" --preview-window=right:30%:wrap)'';

        # zellij
        zl = "zellij";
        zla = "zellij attach $(zellij ls -s | fzf)";
        zln = "zellij --session";
      };

      interactiveShellInit = ''
      # function init
      function fish_greeting
      end
      search_files

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

      # fifc \
      #   -r '^(pacman|paru)(\\h*\\-S)?\\h+' \
      #   -s "pacman --color=always -Ss "$fifc_token" | string match -r \'^[^\\h+].*\'" \
      #   -e '.*/(.*?)\\h.*' \
      #   -f "--query ' '" \
      #   -p 'pacman -Si "$fifc_extracted"'
      '';
      functions = {
        search_files = {
          body = ''
            set -l options "screenfetch 2>/dev/null" \
                               "fastfetch" \
                               "ghfetch -u Gidrex -c magenta --access-token (pass show github_token)" \
                               "starfetch -c magenta"

                set -l selected_command (printf "%s\n" $options | fzf --height 40% --reverse)

                if test -n "$selected_command"
                    eval $selected_command
                else
                    echo "Команда не выбрана."
                end
            end
          '';
        };
        fetch = {
          body = ''


      starfetch -c magenta
          '';
        };
      };
    };
  };
}
