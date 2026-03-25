vim.g.mapleader = " "
local wk = require("which-key")

-- Quick save/quit
vim.keymap.set("n", "<A-w>", ":w<CR>", { silent = true, desc = "Save" })
vim.keymap.set("n", "<A-q>", ":q<CR>", { silent = true, desc = "Quit" })

-- Space Menu
wk.add({
  { "<leader><space>", "<cmd>Telescope find_files<CR>",                        desc = "File Picker" },
  { "<leader>q",       ":!qalc -s 'maxdeci 2' -t -f /dev/stdin<CR>",           desc = "Calculator" },
  { "<leader>m",       ":!foot -d error -T 'Glow Preview' glow -p -w 0 %<CR>", desc = "Glow Preview" },
  { "<leader>a",       "<cmd>AerialToggle!<CR>",                               desc = "Outline (Aerial)" },
  { "<leader>r",       ":e!<CR>",                                              desc = "Reload Buffer" },
})

require('mini.pairs').setup({})
require('mini.comment').setup({
  mappings = { textobject = 'gc', comment = 'gc' }
})
require('mini.surround').setup({
  mappings = {
    add = 'ms',
    delete = 'md',
    replace = 'mr',
  }
})
