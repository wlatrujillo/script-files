vim.opt.ignorecase = true


vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.hidden = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, 'CursorLine', { underline = true }) 

vim.opt.clipboard = "unnamedplus"
