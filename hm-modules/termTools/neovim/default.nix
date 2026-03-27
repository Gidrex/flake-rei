{
  pkgs,
  ...
}:
{
  catppuccin.nvim.enable = false;

  programs.neovim = {
    defaultEditor = false;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim
      render-markdown-nvim
      plenary-nvim
      aerial-nvim
      nvim-treesitter.withAllGrammars
      lualine-nvim
      indent-blankline-nvim
      which-key-nvim
      gitsigns-nvim
      mini-nvim
      telescope-nvim

      # LSP & Completion
      nvim-lspconfig
      blink-cmp
    ];

    extraPackages = with pkgs; [
      # LSP Servers & Tools
      nil # Nix
      lua-language-server
      pyright # Python
      ruff # Python linter/formatter
      ty # Python type checker wrapper
      rust-analyzer
      rustfmt
      deno
      yaml-language-server
      taplo # TOML
    ];

    initLua = ''
      require('init')
    '';
  };

  # Link the lua configuration directory
  xdg.configFile."nvim/lua".source = ./lua;
}
