vim.g.mapleader = " "

vim.keymap.set("i", "jj", "<Esc>", {noremap = true})

vim.api.nvim_set_keymap("n", "<leader>w", [[<Cmd>w<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", [[<Cmd>q<CR>]], { noremap = true, silent = true })
