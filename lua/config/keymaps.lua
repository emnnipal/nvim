-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- select all text with ctrl + a
vim.keymap.set({ "", "n" }, "<D-a>", "<Esc>ggVG")

-- apply escape shortcuts in insert mode and command mode
vim.keymap.set({ "i", "c" }, "jk", "<Esc>")
vim.keymap.set({ "i", "c" }, "kj", "<Esc>")

-- apply highlighting shortcuts in all modes and visual mode
-- vim.keymap.del({ "", "v" }, "K", nil)
vim.keymap.set({ "", "v" }, "J", "10j")
-- TODO: remap not working
vim.keymap.set({ "", "v" }, "K", "10k", { remap = true })
vim.keymap.set({ "", "v" }, "H", "^")
vim.keymap.set({ "", "v" }, "L", "$")

-- TODO: description not updating in which-key
vim.keymap.set("n", "<leader>w", ":update<CR>", { desc = "Save" })
