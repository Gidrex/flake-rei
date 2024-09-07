-- my combos
-- vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true })

-- leader to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.api.nvim_set_keymap('n', ' ', '', { noremap = true })
vim.api.nvim_set_keymap('v', ' ', '', { noremap = true })
vim.api.nvim_set_keymap('x', ' ', '', { noremap = true })
vim.api.nvim_set_keymap('s', ' ', '', { noremap = true })
vim.api.nvim_set_keymap('o', ' ', '', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'n', ' ', '', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'v', ' ', '', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'x', ' ', '', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 's', ' ', '', { noremap = true })
vim.api.nvim_buf_set_keymap(0, 'o', ' ', '', { noremap = true })

-- lazygit
vim.api.nvim_set_keymap('n', '<leader>Z', '<cmd>LazyGit<cr>', { noremap = true, silent = true })

-- lsp trouble
vim.api.nvim_set_keymap('n', '<leader>tt', '<cmd>TroubleToggle document_diagnostics<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tq', '<cmd>TroubleToggle quickfix<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>td', '<cmd>TroubleToggle lsp_definitions<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>tr', '<cmd>TroubleToggle lsp_references<cr>', { noremap = true })

-- telescope
vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>lua require('telescope.builtin').help_tags()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fd', "<cmd>lua require('telescope.builtin').diagnostics()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fi', "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fw', "<cmd>Telescope telescope-cargo-workspace switch<cr>", { noremap = true })

-- DAP
-- vim.api.nvim_set_keymap('n', '<leader>db', "<cmd>lua require('dap').toggle_breakpoint()<cr>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>dc', "<cmd>lua require('dap').continue()<cr>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>so', "<cmd>lua require('dap').step_over()<cr>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>si', "<cmd>lua require('dap').step_into()<cr>", { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>du', "<cmd>lua require('dapui').toggle()<cr>", { noremap = true })

-- SnipRun
vim.api.nvim_set_keymap('n', '<leader>sr', "<cmd>lua require('sniprun').run()<cr>", { noremap = true })

-- Quickfix
vim.api.nvim_set_keymap('n', '<leader>qn', '<cmd>:cn<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>qp', '<cmd>:cp<CR>', { noremap = true })

-- Harpoon
vim.api.nvim_set_keymap('n', '<leader>s', '<cmd>lua require("harpoon.mark").add_file()<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-e>', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', { noremap = true })

-- Clang
-- vim.api.nvim_set_keymap('n', '<leader>he', '<cmd>ClangdSwitchSourceHeader<cr>', { noremap = true, silent = true })

-- Oil
vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Oil<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>tabnew<cr><cmd>Oil<cr>', { noremap = true, silent = true })


-- Neorg
-- vim.api.nvim_set_keymap('n', '<leader>ne', '<cmd>Neorg index<cr>', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<leader>nr', '<cmd>Neorg return<cr>', { noremap = true })
--
-- barbar (tabs)
--
