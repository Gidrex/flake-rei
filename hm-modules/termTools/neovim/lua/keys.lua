vim.g.mapleader = " "
local wk = require("which-key")

-- Quick save/quit
vim.keymap.set("n", "<A-w>", ":w<CR>", { silent = true, desc = "Save" })
vim.keymap.set("n", "<A-q>", ":q<CR>", { silent = true, desc = "Quit" })

-- LazyGit on Z (and disable ZZ)
local function open_lazygit()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    style = 'minimal',
    border = 'rounded'
  })

  vim.fn.termopen('lazygit', {
    on_exit = function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
  })
  vim.cmd('startinsert')
end

vim.keymap.set("n", "ZZ", "<nop>")
vim.keymap.set("n", "Z", open_lazygit, { silent = true, desc = "LazyGit" })

-- Space Menu
wk.add({
  { "<leader>f",  "<cmd>Telescope find_files<CR>",              desc = "File Picker" },
  { "<leader>b",  "<cmd>Telescope buffers<CR>",                 desc = "Buffers" },
  { "<leader>g",  "<cmd>Telescope git_status<CR>",              desc = "Git Status (Diff)" },
  { "<leader>/",  "<cmd>Telescope live_grep<CR>",               desc = "Live Grep" },
  { "<leader>q",  ":!qalc -s 'maxdeci 2' -t -f /dev/stdin<CR>", desc = "Calculator" },
  { "<leader>a",  "<cmd>AerialToggle!<CR>",                     desc = "Outline (Aerial)" },
  { "<leader>r",  ":e!<CR>",                                    desc = "Reload Buffer" },
  { "<leader>l",  group = "LSP" },
  { "<leader>la", vim.lsp.buf.code_action,                      desc = "Code Action" },
  { "<leader>lr", vim.lsp.buf.rename,                           desc = "Rename" },
  { "<leader>ld", vim.lsp.buf.definition,                       desc = "Go to Definition" },
  { "<leader>lh", vim.lsp.buf.hover,                            desc = "Hover" },
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
