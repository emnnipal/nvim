return {
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "echasnovski/mini.ai",
    enabled = false,
  },
  {
    "snacks.nvim",
    opts = {
      indent = {
        scope = { enabled = false },
      },
      input = { -- TODO: make snacks input the same as dressing nvim window position
        enabled = false,
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>w", "<Cmd>update<CR>", desc = "Write" },
        { "<leader>W", "<Cmd>noautocmd w<CR>", desc = "Save without formatting" },
        { "<leader>bh", "<Cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
        { "<leader>bl", "<Cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },

        { "<leader>m", "<Cmd>TSJToggle<CR>", desc = "Toggle split/join" },
        { "<leader>j", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
        { "<leader>k", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },

        { "<leader>cL", "<Cmd>LspRestart<CR>", desc = "Restart LSP" },

        {
          "<leader>gg",
          function()
            ---@module 'snacks'
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

        {
          "<leader>gf",
          function()
            Snacks.lazygit.log_file()
          end,
          desc = "Lazygit Current File History",
        },
        {
          "<leader>gl",
          function()
            Snacks.lazygit.log({ cwd = LazyVim.root.git() })
          end,
          desc = "Lazygit Log",
        },
        {
          "<leader>gL",
          function()
            Snacks.lazygit.log()
          end,
          desc = "Lazygit Log (cwd)",
        },
      },
      icons = {
        mappings = false, -- disable all icons in which-key
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
            "node_modules",
          },
          always_show = {
            ".env",
          },
        },
      },
    },
  },

  -- additional plugins
  {
    "Wansmer/treesj",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 1200,
    },
  },
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    opts = {},
  },
  {
    "mg979/vim-visual-multi",
    event = "BufReadPre",
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    opts = {
      default_mappings = false,
    },
  },
  {
    "phaazon/hop.nvim",
    event = "BufReadPre",
    config = function()
      local hop = require("hop")
      hop.setup()
      vim.keymap.set("", "m", function()
        hop.hint_words()
      end, { remap = true, desc = "Hop" })
    end,
  },
}
