---@diagnostic disable: undefined-global

-- Theme: Catppuccin Mocha
require("catppuccin").setup({
  flavour = "mocha",
  compile = {
    enabled = false,
  }
})
vim.cmd.colorscheme "catppuccin"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = ""  -- disable mouse
vim.opt.termguicolors = true
vim.opt.wrap = true -- soft-wrap
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.laststatus = 3 -- global statusline
vim.opt.shada = "!,'100,<50,s10,h"

vim.opt.guicursor =
"n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- UI Plugins Setup
require("ibl").setup({
  indent = { char = "▏" },
  scope = { enabled = false },
})

require("render-markdown").setup({})

require("telescope").setup({})

require("aerial").setup({
  on_attach = function(bufnr)
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
  end,
})

-- Treesitter setup (updated for 1.0.0+)
local status_ts, ts_configs = pcall(require, "nvim-treesitter.configs")
if status_ts then
  ts_configs.setup({
    highlight = { enable = true },
  })
else
  -- If configs module is missing (v1.0.0+), treesitter highlight might be managed differently
  -- or we can use the built-in vim.treesitter.start for certain cases.
  -- Most users on 1.0.0 don't need manual setup for basic highlights if grammars are present.
end

require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = "│",
    section_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { { "mode", fmt = function(str) return str:upper() end } },
    lualine_b = { "branch", "filetype" },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics" },
    lualine_y = { "selectioncount", "progress" },
    lualine_z = { "location", "encoding" },
  },
})

require("which-key").setup({})

-- Load Keybindings
require("keys")
