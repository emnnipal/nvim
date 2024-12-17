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
    "ahmedkhalf/project.nvim",
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
