return {
  -- floating neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = LazyVim.has_extra("editor.neo-tree"),
    init = function() end,
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
      default_component_configs = {
        type = {
          enabled = false,
        },
        -- icon = {
        --   enabled = false,
        -- },
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
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = vim.uv.cwd(),
            reveal = true,
            position = "float",
          })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true, position = "float" })
        end,
        desc = "Git Explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true, position = "float" })
        end,
        desc = "Buffer Explorer",
      },
    },
  },
}
