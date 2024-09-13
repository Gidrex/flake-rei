require('lspsaga').setup({
  ui = {
    border = 'rounded',
  },
  symbol_in_winbar = {
    enable = false,
  },
  code_action = {
    keys = {
      quit = "<Esc>",
      exec = "<CR>",
    },
  },
  finder = {
    keys = {
      edit = "<CR>",
      vsplit = "v",
      split = "s",
      quit = { "q", "<Esc>" },
    },
  },
})
