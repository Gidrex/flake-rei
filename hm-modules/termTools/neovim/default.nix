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
    ];

    initLua = ''
      require('init')
    '';
  };

  # Link the lua configuration directory
  xdg.configFile."nvim/lua".source = ./lua;
}
