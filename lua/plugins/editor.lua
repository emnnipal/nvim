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
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          -- return "(" .. count .. ")"
          -- TODO: change icons for warning and error. make it smaller than the one provided by lazyvim
          return "●"
        end,
        indicator = {
          -- icon = "▎", -- this should be omitted if indicator style is not 'icon'
          -- style = "icon" | "underline" | "none",
          style = "none",
        },

        modified_icon = "●",
        -- this takes more space so ew use just an icon instead
        -- modified_icon = "[+]",

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
        enabled = false,
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
