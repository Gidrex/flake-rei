{ pkgs, lib, ... }: 
let
  fromGitHub = rev: ref: repo: pkgs.vimUtils.buildVimPlugin {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
      rev = rev;
    };
  };
in {
  home.packages = with pkgs; [
    # LSP Servers
    pyright
    cmake-language-server
    nil
    rust-analyzer
    ansible-language-server
    nodePackages_latest.dockerfile-language-server-nodejs
    nodePackages.vim-language-server
    lua-language-server
    buf-language-server
    vscode-langservers-extracted
    nixpkgs-fmt
    typescript-language-server
    eslint_d
    lua54Packages.luarocks-nix
  ];
  programs.neovim = {
    extraPackages = with pkgs; [ luajitPackages.lua-utils-nvim ];
    plugins = [
      # Theme
      {
        plugin = pkgs.vimPlugins.catppuccin-nvim;
        config = "vim.cmd[[colorscheme catppuccin-mocha]]";
        type = "lua";
      }     

      {
        plugin = pkgs.vimPlugins.yazi-nvim;
        config = ''vim.keymap.set("n", "<leader>g", function() require("yazi").yazi() end)'';
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.hop-nvim;
        config = "require'hop'.setup{ keys = 'etovxqpdygfblzhckisuran', case_insensitive = true, char2_fallback_key = '<CR>'}";
        type = "lua";
      }
      { 
        plugin = pkgs.vimPlugins.nvim-highlight-colors;
        config = builtins.readFile ./config/setup/hightlight-colors.lua;
        type = "lua";
      }
      # {
      #   plugin = pkgs.vimPlugins.barbar-nvim;
      #   config = builtins.readFile ./config/setup/barbar.lua;
      #   type = "lua";
      # }

      # Treesitter
      {
        plugin = pkgs.vimPlugins.nvim-treesitter;
        config = builtins.readFile ./config/setup/treesitter.lua;
        type = "lua";
      }
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      pkgs.vimPlugins.nvim-treesitter-textobjects
      {
        plugin = pkgs.vimPlugins.nvim-lspconfig;
        config = builtins.readFile ./config/setup/lspconfig.lua;
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.lspsaga-nvim;
        config = builtins.readFile ./config/setup/lspsaga.lua;
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.mason-nvim;
        config = ''require("mason").setup()'';
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.mason-lspconfig-nvim;
        config = ''require("mason-lspconfig").setup()'';
        type = "lua";
      }

      # Telescope
      {
        plugin = pkgs.vimPlugins.telescope-nvim;
        config = builtins.readFile ./config/setup/telescope.lua;
        type = "lua";
      }
      pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.harpoon

      # cmp
      {
        plugin = pkgs.vimPlugins.nvim-cmp;
        config = builtins.readFile ./config/setup/cmp.lua;
        type = "lua";
      }
      pkgs.vimPlugins.cmp-nvim-lsp
      pkgs.vimPlugins.cmp-buffer
      pkgs.vimPlugins.cmp-cmdline
      pkgs.vimPlugins.cmp_luasnip
      pkgs.vimPlugins.cmp-cmdline
      pkgs.vimPlugins.cmp-path

      # Tpope
      pkgs.vimPlugins.vim-surround
      pkgs.vimPlugins.vim-sleuth
      pkgs.vimPlugins.vim-repeat

      # QoL
      pkgs.vimPlugins.lspkind-nvim
      pkgs.vimPlugins.rainbow
      pkgs.vimPlugins.nvim-web-devicons
      # pkgs.vimPlugins.surround-nvim # again?
      pkgs.vimPlugins.lazygit-nvim
      {
        plugin = fromGitHub "6218a401824c5733ac50b264991b62d064e85ab2" "main" "m-demare/hlargs.nvim";
        config = "require('hlargs').setup()";
        type = "lua";
      }
      {
        plugin = fromGitHub "4c3bc2cd46085b36b2873c1ae9086aee404b3d90" "main" "apple/pkl-neovim";
      }
      { # ru lang support
        plugin = fromGitHub "e952abbea092e420b128936a0c284fb522612c3a" "master" "powerman/vim-plugin-ruscmd";
      }
      {
        plugin = pkgs.vimPlugins.oil-nvim;
        config = "require('oil').setup({ view_options = { show_icons = false, },})";
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.fidget-nvim;
        config = "require('fidget').setup{}";
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.trouble-nvim;
        config = "require('trouble').setup {}";
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.luasnip;
        config = builtins.readFile ./config/setup/luasnip.lua;
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.comment-nvim;
        config = "require('Comment').setup()";
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.gitsigns-nvim;
        config = "require('gitsigns').setup()";
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.lualine-nvim;
        config = builtins.readFile ./config/setup/lualine.lua;
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.noice-nvim;
        config = builtins.readFile ./config/setup/noice.lua;
        type = "lua";
      }

      # Debugging
      pkgs.vimPlugins.nvim-dap-ui
      pkgs.vimPlugins.nvim-dap-virtual-text
      {
        plugin = pkgs.vimPlugins.nvim-dap;
        config = builtins.readFile ./config/setup/dap.lua;
        type = "lua";
      }
      {
        plugin = pkgs.vimPlugins.rustaceanvim;
        config = builtins.readFile ./config/setup/rustaceanvim.lua;
        type = "lua";
      }
    ];

    extraLuaConfig = ''
      ${builtins.readFile ./config/mappings.lua}
      ${builtins.readFile ./config/options.lua}
    '';
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
}
