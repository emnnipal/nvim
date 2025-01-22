-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- make completion and documentation not transparent
vim.o.pumblend = 0
-- vim.o.winblend = 1

vim.opt.conceallevel = 0

vim.o.termsync = false

vim.g.lazyvim_eslint_auto_format = false

vim.g.snacks_animate = false
