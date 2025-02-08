---@diagnostic disable: missing-fields

---@type snacks.layout.Box
local vertical_layout = {
  backdrop = false,
  width = 0.5,
  min_width = 100,
  height = 0.6,
  min_height = 30,
  box = "vertical",
  border = "rounded",
  title = "{source} {live}",
  title_pos = "center",
  -- row = 1,
  { win = "preview", height = 0.5, border = "bottom" },
  { win = "input", height = 1, border = "bottom" },
  { win = "list" },
}

return {
  {
    "folke/snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      picker = {
        formatters = {
          file = {
            -- filename_first = true,
            truncate = 90, -- truncate the file path to (roughly) this length
          },
        },
      },
    },
    keys = {
      {
        "<leader>sg",
        LazyVim.pick("live_grep", {
          layout = {
            preview = false,
            layout = vertical_layout,
          },
        }),
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sG",
        LazyVim.pick("live_grep", {
          root = false,
          layout = {
            preview = false,
            layout = vertical_layout,
          },
        }),
        desc = "Grep (cwd)",
      },
      {
        "<leader>ff",
        LazyVim.pick("files", { layout = { preview = false, layout = vertical_layout } }),
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fF",
        LazyVim.pick("files", { root = false, layout = { preview = false, layout = vertical_layout } }),
        desc = "Find Files (cwd)",
      },
      -- {
      --   "<leader>ff",
      --   LazyVim.pick("smart", {
      --     filter = { cwd = true },
      --     layout = {
      --       preview = false,
      --       layout = vertical_layout,
      --     },
      --   }),
      --   desc = "Find Files (Root Dir)",
      -- },
      -- {
      --   "<leader>fF",
      --   LazyVim.pick("smart", {
      --     filter = { cwd = true },
      --     root = false,
      --     layout = {
      --       preview = false,
      --       layout = vertical_layout,
      --     },
      --   }),
      --   desc = "Find Files",
      -- },

      {
        "<leader>fr",
        LazyVim.pick("oldfiles", {
          filter = { cwd = true },
          layout = {
            preview = false,
            layout = vertical_layout,
          },
        }),
        desc = "Recent (Root Dir)",
      },
      {
        "<leader>fR",
        LazyVim.pick("oldfiles", {
          root = false,
          filter = { cwd = true },
          layout = {
            preview = false,
            layout = vertical_layout,
          },
        }),
        desc = "Recent",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      if LazyVim.pick.want() ~= "snacks" then
        return
      end
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()
      vim.list_extend(Keys, {
        {
          "gd",
          function()
            Snacks.picker.lsp_definitions({
              layout = {
                preview = true,
                layout = vertical_layout,
              },
            })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
        {
          "gr",
          function()
            Snacks.picker.lsp_references({
              layout = {
                preview = true,
                layout = vertical_layout,
              },
            })
          end,
          nowait = true,
          desc = "References",
        },
        {
          "<leader>ss",
          function()
            Snacks.picker.lsp_symbols({
              filter = LazyVim.config.kind_filter,
              layout = {
                preview = true,
                layout = vertical_layout,
              },
            })
          end,
          desc = "LSP Symbols",
          has = "documentSymbol",
        },
        {
          "<leader>sS",
          function()
            Snacks.picker.lsp_workspace_symbols({
              filter = LazyVim.config.kind_filter,
              layout = { preview = true, layout = vertical_layout },
            })
          end,
          desc = "LSP Workspace Symbols",
          has = "workspace/symbols",
        },
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    optional = true,
    -- stylua: ignore
    keys = {
      {
        "<leader>st",
        function()
          Snacks.picker.todo_comments({
            layout = {
              preview = true,
              layout = vertical_layout,
            },
          })
        end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function()
          Snacks.picker.todo_comments({
            keywords = { "TODO", "FIX", "FIXME" },
            layout = {
              preview = true,
              layout = vertical_layout,
            },
          })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },

  -- {
  --   "stevearc/dressing.nvim",
  --   -- Enable regardless of chosen picker. Originally, this is only enabled for telescope extra.
  --   enabled = true,
  --
  --   -- configuration is from telescope extra
  --   lazy = true,
  --   init = function()
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     -- vim.ui.select = function(...)
  --     --   require("lazy").load({ plugins = { "dressing.nvim" } })
  --     --   return vim.ui.select(...)
  --     -- end
  --
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     vim.ui.input = function(...)
  --       require("lazy").load({ plugins = { "dressing.nvim" } })
  --       return vim.ui.input(...)
  --     end
  --   end,
  -- },
}
