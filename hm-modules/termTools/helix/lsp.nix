{ pkgs, lib, config, ... }:
let
  denoConfig = {
    shebangs = [ "deno" ];
    roots = [ "deno.json" "deno.jsonc" ];
    auto-format = true;
    language-servers = [ "biome" "deno-lsp" ];
    formatter = {
      command = "${pkgs.deno}/bin/deno";
      args = [ "fmt" "-" "--options-single-quote=false" ];
    };
    indent = {
      tab-width = 2;
      unit = "  ";
    };
  };

in {
  home.packages = with pkgs;
    lib.mkIf config.programs.helix.enable [
      # Nix
      nil
      nixd
      nixfmt-classic

      # C/C++
      # cmake-language-server
      lldb
      libclang

      # Docker
      dockerfile-language-server

      # Kubernetes
      helm-ls

      # Shells
      nodePackages_latest.bash-language-server
      fish-lsp

      # Lua
      lua-language-server

      # Go
      gopls
      golangci-lint
      golangci-lint-langserver
      delve

      # python
      ty
      python313Packages.jedi-language-server
      python313Packages.python-lsp-server

      # toml
      taplo
      tombi

      # html + css + json + js/ts
      vscode-langservers-extracted
      biome

      # yaml
      yaml-language-server

      # markdown
      markdown-oxide
      marksman

      # just
      just-lsp

      # Rice
      hyprls
    ];

  programs.ruff = {
    enable = true;
    settings = {
      # line-length = 120;
      lint.per-file-ignores = { "__init__.py" = [ "F401" ]; };
      lint.select = [ "E4" "E7" "E9" "F" ];
    };
  };

  programs.helix = {
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-classic}/bin/nixfmt";
      }
      {
        name = "rust";
        auto-format = true;
        language-servers = [ "rust-analyzer" ];
        indent = {
          tab-width = 2;
          unit = "  ";
        };
        formatter = {
          command = "${pkgs.rustfmt}/bin/rustfmt";
          args = [ "--edition" "2021" "--config" "tab_spaces=2" ];
        };
      }
      {
        name = "nu";
        file-types = [ "nu" ];
        language-servers = [ "${pkgs.nushell}/bin/nu --lsp" ];
      }
      {
        name = "python";
        auto-format = true;
      }
      {
        name = "lua";
        auto-format = true;
      }
      (denoConfig // { name = "typescript"; })
      (denoConfig // { name = "javascript"; })
      {
        name = "dart";
        auto-format = true;
        language-servers = [ "dart" ];
        formatter = {
          command = "dart";
          args = [ "format" ];
        };
      }
    ];

    languages.language-server = {
      biome = {
        command = "biome";
        args = [ "lsp-proxy" ];
      };

      deno-lsp = {
        command = "deno";
        args = [ "lsp" ];
        config = {
          deno = {
            enable = true;
            unstable = true;
            inlayHints = {
              #   enumMemberValues = { enabled = true; };
              #   functionLikeReturnTypes = { enabled = true; };
              #   parameterNames = { enabled = "all"; };
              #   parameterTypes = { enabled = true; };
              propertyDeclarationTypes = { enabled = true; };
              #   variableTypes = { enabled = true; };
            };
          };
        };
      };

      rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        config = {
          check = { command = "clippy"; };
          inlayHints = {
            bindingModeHints = { enable = true; };
            chainingHints = { enable = true; };
            closingBraceHints = { enable = true; };
            closureCaptureHints = { enable = true; };
            closureReturnTypeHints = { enable = "always"; };
            closureStyle = "impl_fn";
            discriminantHints = { enable = "always"; };
            expressionAdjustmentHints = { enable = "always"; };
            implicitDrops = { enable = true; };
            lifetimeElisionHints = {
              enable = "always";
              useParameterNames = true;
            };
            parameterHints = { enable = true; };
            reborrowHints = { enable = "always"; };
            typeHints = {
              enable = true;
              hideClosureInitialization = false;
              hideNamedConstructor = false;
            };
          };
          cargo = {
            buildScripts = { enable = true; };
            features = "all";
          };
          procMacro = { enable = true; };
          rustfmt = { rangeFormatting = { enable = true; }; };
        };
      };

      dart = {
        command = "${pkgs.flutter}/bin/dart";
        args = [ "language-server" "--protocol=lsp" ];
      };
    };
  };
}
