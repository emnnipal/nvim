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

vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Display hover info" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<A-k>", "<Plug>(VM-Add-Cursor-Up)")
vim.keymap.set("n", "<A-j>", "<Plug>(VM-Add-Cursor-Down)")

-- terminal
local lazyterm = function()
  LazyVim.terminal(nil, { cwd = LazyVim.root(), border = "rounded" })
end
vim.keymap.set("n", "<C-\\>", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Close Terminal" })

-- which-key keymap
local which_key = require("which-key")
which_key.register({
  ["<leader>w"] = { "<Cmd>update<CR>", "Save" },
  ["<leader>W"] = { "<Cmd>noautocmd w<CR>", "Save without formatting" },
  ["<leader>b"] = {
    h = { "<Cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
    l = { "<Cmd>BufferLineCloseRight<cr>", "Close all to the right" },
  },
  ["<leader>s"] = {
    ["/"] = {
      "<Cmd>Telescope current_buffer_fuzzy_find<CR>",
      "Fuzzy search in current buffer",
    },
  },
  ["<leader>m"] = { "<Cmd>TSJToggle<CR>", "Toggle split/join" },
  ["<leader>j"] = { "<Cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
  ["<leader>k"] = { "<Cmd>BufferLineCycleNext<CR>", "Next Buffer" },
  ["<leader>c"] = {
    L = { "<Cmd>LspRestart<CR>", "Restart LSP" },
  },
  ["<leader>g"] = {
    g = {
      function()
        LazyVim.lazygit({
          cwd = LazyVim.root.git(),
          size = { width = 1, height = 1 },
        })
      end,
      "Lazygit (cwd)",
    },
  },
  ["<leader>i"] = {
    name = "Utilities",
    c = {
      name = " Resolve Git Conflicts",
      a = { "<Cmd>GitConflictListQf<CR>", "Get all conflict to quickfix" },
      b = { "<Cmd>GitConflictChooseBoth<CR>", "Choose both" },
      j = { "<Cmd>GitConflictPrevConflict<CR>", "Move to previous conflict" },
      k = { "<Cmd>GitConflictNextConflict<CR>", "Move to next conflict" },
      n = { "<Cmd>GitConflictChooseNone<CR>", "Choose none" },
      o = { "<Cmd>GitConflictChooseOurs<CR>", "Choose ours" },
      t = { "<Cmd>GitConflictChooseTheirs<CR>", "Choose theirs" },
    },
    e = { "<Cmd>EslintFixAll<CR>", "Fix eslint errors" },
    t = { "<Cmd>vs#<CR>", "Reopen recently closed buffer" },
  },
  ["<leader>q"] = {
    c = {
      LazyVim.ui.bufremove,
      "Close Buffer",
    },
  },
})
