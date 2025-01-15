-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- select all text with cmd + a
vim.keymap.set({ "", "n" }, "<D-a>", "<Esc>ggVG")

-- escape shortcuts
vim.keymap.set({ "i", "c" }, "jk", "<Esc>")
vim.keymap.set({ "i", "c" }, "kj", "<Esc>")

-- highlighting shortcuts
vim.keymap.set({ "", "v" }, "J", "10j")
vim.keymap.set({ "", "v" }, "K", "10k")
vim.keymap.set({ "", "v" }, "H", "^")
vim.keymap.set({ "", "v" }, "L", "$")

vim.keymap.set("n", "gh", function()
  return vim.lsp.buf.hover()
end, { desc = "Display hover info" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<A-k>", "<Plug>(VM-Add-Cursor-Up)")
vim.keymap.set("n", "<A-j>", "<Plug>(VM-Add-Cursor-Down)")

-- terminal
local lazyterm = function()
  Snacks.terminal(nil, { cwd = LazyVim.root(), border = "rounded" })
end
vim.keymap.set("n", "<C-\\>", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Close Terminal" })
