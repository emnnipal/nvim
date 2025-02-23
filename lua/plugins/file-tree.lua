return {
  -- floating neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = LazyVim.has_extra("editor.neo-tree"),
    init = function()
      -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
      -- because `cwd` is not set up properly.
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
        desc = "Start Neo-tree with directory",
        once = true,
        callback = function()
          if package.loaded["neo-tree"] then
            return
          else
            local stats = vim.uv.fs_stat(vim.fn.argv(0))
            if stats and stats.type == "directory" then
              require("neo-tree.command").execute({
                toggle = true,
                dir = LazyVim.root(),
                reveal = true,
                position = "float",
              })
            end
          end
        end,
      })
    end,
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
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
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

  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    ---@diagnostic disable-next-line: missing-fields
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
              layout = {
                -- position = "float"
                width = 120,
              },
            },
            ---@diagnostic disable: missing-fields
            icons = {
              -- tree = {
              --   vertical = "│  ",
              --   middle = "├╴ ",
              --   last = "└╴ ",
              -- },
            },
          },
        },
      },
    },
  },
}
