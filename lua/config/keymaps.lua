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

-- which-key keymap
local which_key = require("which-key")
which_key.add({
  { "<leader>bh", "<Cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
  { "<leader>bl", "<Cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },

  { "<leader>s/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy search in current buffer" },
  { "<leader>m", "<Cmd>TSJToggle<CR>", desc = "Toggle split/join" },
  { "<leader>j", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
  { "<leader>k", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },

  { "<leader>cL", "<Cmd>LspRestart<CR>", desc = "Restart LSP" },

  {
    "<leader>gg",
    function()
      Snacks.lazygit({
        cwd = LazyVim.root.git(),
        win = {
          width = 0,
          height = 0,
          style = "lazygit",
        },
      })
    end,
    desc = "Lazygit (cwd)",
  },

  { "<leader>i", group = "Utilities" },
  { "<leader>ie", "<Cmd>EslintFixAll<CR>", desc = "Fix eslint errors" },
  { "<leader>it", "<Cmd>vs#<CR>", desc = "Reopen recently closed buffer" },

  { "<leader>ic", group = "Resolve Git Conflicts" },
  { "<leader>ica", "<Cmd>GitConflictListQf<CR>", desc = "Get all conflict to quickfix" },
  { "<leader>icb", "<Cmd>GitConflictChooseBoth<CR>", desc = "Choose both" },
  { "<leader>icj", "<Cmd>GitConflictPrevConflict<CR>", desc = "Move to previous conflict" },
  { "<leader>ick", "<Cmd>GitConflictNextConflict<CR>", desc = "Move to next conflict" },
  { "<leader>icn", "<Cmd>GitConflictChooseNone<CR>", desc = "Choose none" },
  { "<leader>ico", "<Cmd>GitConflictChooseOurs<CR>", desc = "Choose ours" },
  { "<leader>ict", "<Cmd>GitConflictChooseTheirs<CR>", desc = "Choose theirs" },

  {
    "<leader>qc",
    function()
      Snacks.bufdelete()
    end,
    desc = "Close Buffer",
  },
})
