return {
  -- floating neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    init = function() end,
    opts = {
      default_component_configs = {
        type = {
          enabled = false,
        },
      },
      window = {
        popup = {
          size = {
            width = 120,
          },
        },
      },
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = LazyVim.root(),
            reveal = true,
            position = "float",
          })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    },
  },

  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      explorer = {
        enabled = LazyVim.has_extra("editor.snacks_explorer"),
        replace_netrw = true,
      },
      picker = {
        sources = {
          explorer = {
            auto_close = true,
            layout = {
              preset = "vertical",
              -- layout = { position = "float" },
            },
            ---@diagnostic disable: missing-fields
            icons = {
              tree = {
                vertical = "│  ",
                middle = "├╴ ",
                last = "└╴ ",
              },
            },
          },
        },
      },
    },
  },
}
