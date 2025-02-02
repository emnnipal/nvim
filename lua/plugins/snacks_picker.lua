---@diagnostic disable: missing-fields

---@type snacks.layout.Box
local vertical_picker_layout = {
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
            truncate = 100, -- truncate the file path to (roughly) this length
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
            layout = vertical_picker_layout,
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
            layout = vertical_picker_layout,
          },
        }),
        desc = "Grep (cwd)",
      },
      {
        "<leader>ff",
        LazyVim.pick("smart", {
          filter = { cwd = true },
          layout = {
            preview = false,
            layout = vertical_picker_layout,
          },
        }),
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fF",
        LazyVim.pick("smart", {
          filter = { cwd = true },
          root = false,
          layout = {
            preview = false,
            layout = vertical_picker_layout,
          },
        }),
        desc = "Find Files",
      },

      {
        "<leader>fr",
        LazyVim.pick("oldfiles", {
          filter = { cwd = true },
          layout = {
            preview = false,
            layout = vertical_picker_layout,
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
            layout = vertical_picker_layout,
          },
        }),
        desc = "Recent",
      },

      -- { "<leader>fs", LazyVim.pick("smart", { filter = { cwd = true } }), desc = "Smart Find Files (Root Dir)" },
      -- { "<leader>fS", LazyVim.pick("smart", { filter = { cwd = true }, root = false }), desc = "Smart Find Files" },
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
                layout = vertical_picker_layout,
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
                layout = vertical_picker_layout,
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
                layout = vertical_picker_layout,
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
              layout = { preview = true, layout = vertical_picker_layout },
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
              layout = vertical_picker_layout,
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
              layout = vertical_picker_layout,
            },
          })
        end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },
}
