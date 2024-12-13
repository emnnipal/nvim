-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- make completion and documentation not transparent
vim.o.pumblend = 0
-- vim.o.winblend = 1

vim.opt.conceallevel = 0

-- Disable termsync to prevent buffering of screen updates during redraw cycles
-- This is to address the lagging issue experienced in LazyGit within LazyVim
vim.o.termsync = false

vim.g.lazyvim_eslint_auto_format = false

vim.g.snacks_animate = false
