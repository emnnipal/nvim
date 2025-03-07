return {
  {
    "echasnovski/mini.ai",
    enabled = false,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        -- always_show_bufferline = false,
        -- diagnostics = false,
        -- diagnostics_update_on_event = false,
      },
    },
  },
  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      indent = {
        scope = { enabled = false },
      },
      input = {
        enabled = true,
        icon_pos = false,
        win = {
          title_pos = "left",
          width = 35,
          relative = "cursor",
          row = -3,
          col = 0,
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
}
