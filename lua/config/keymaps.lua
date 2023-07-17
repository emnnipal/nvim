local Util = require("lazyvim.util")
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
vim.keymap.set({ "", "v" }, "J", "10j")
vim.keymap.set({ "", "v" }, "K", "10k")
vim.keymap.set({ "", "v" }, "H", "^")
vim.keymap.set({ "", "v" }, "L", "$")

vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Display hover info" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "<A-k>", "<Plug>(VM-Add-Cursor-Up)")
vim.keymap.set("n", "<A-j>", "<Plug>(VM-Add-Cursor-Down)")

-- override some which-key keymaps
vim.keymap.set("n", "<leader>w", ":update<CR>", { desc = "Save", silent = true })
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w<cr>", { desc = "Save without formatting", silent = true })

local lazyterm = function()
  Util.float_term(nil, { cwd = Util.get_root(), border = "rounded" })
end

vim.keymap.set("n", "<C-\\>", lazyterm, { desc = "Terminal (root dir)" })
vim.keymap.set("t", "<C-\\>", "<cmd>close<cr>", { desc = "Close Terminal" })

vim.keymap.set("n", "<leader>gg", function()
  Util.float_term({ "lazygit" }, {
    size = {
      width = 1,
      height = 1,
    },
    esc_esc = false, -- disable <esc><esc> to go to normal mode when in lazygit
  })
end, { desc = "Lazygit (cwd)" })

-- which-key keymap
local which_key = require("which-key")
which_key.register({
  ["<leader>b"] = {
    h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
    l = { "<cmd>BufferLineCloseRight<cr>", "Close all to the right" },
  },
  ["<leader>m"] = { ":TSJToggle<CR>", "Toggle split/join" },
  ["<leader>j"] = { ":BufferLineCyclePrev<CR>", "Previous Buffer" },
  ["<leader>k"] = { ":BufferLineCycleNext<CR>", "Next Buffer" },
  ["<leader>c"] = {
    R = { ":LspRestart<CR>", "Restart LSP" },
  },
  ["<leader>i"] = {
    name = "Utilities",
    c = {
      name = " Resolve Git Conflicts",
      a = { ":GitConflictListQf<CR>", "Get all conflict to quickfix" },
      b = { ":GitConflictChooseBoth<CR>", "Choose both" },
      j = { ":GitConflictPrevConflict<CR>", "Move to previous conflict" },
      k = { ":GitConflictNextConflict<CR>", "Move to next conflict" },
      n = { ":GitConflictChooseNone<CR>", "Choose none" },
      o = { ":GitConflictChooseOurs<CR>", "Choose ours" },
      t = { ":GitConflictChooseTheirs<CR>", "Choose theirs" },
    },
    e = { ":EslintFixAll<CR>", "Fix eslint errors" },
  },
  ["<leader>q"] = {
    c = {
      function()
        require("mini.bufremove").delete(0, false)
      end,
      "Close Buffer",
    },
  },
})
