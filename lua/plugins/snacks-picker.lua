---@diagnostic disable: missing-fields, assign-type-mismatch

---@type snacks.layout.Box
local vertical_layout = {
  backdrop = false,
  width = 110,
  height = 0.70,
  box = "vertical",
  border = "rounded",
  title = "{source} {live}",
  title_pos = "center",
  -- row = 1,
  { win = "preview", height = 0.6, border = "bottom" },
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
        ui_select = true,
        formatters = {
          file = {
            -- filename_first = true,
            truncate = 90, -- truncate the file path to (roughly) this length
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>R", function() Snacks.picker.resume() end, desc = "Use Recent Picker" },
      { "<leader>sg",  LazyVim.pick("live_grep", { layout = { preview = true, layout = vertical_layout } }), desc = "Grep (Root Dir)" },
      { "<leader>sG", LazyVim.pick("live_grep", { root = false, layout = { preview = true, layout = vertical_layout } }), desc = "Grep (cwd)" },
      { "<leader>/", "<leader>sG", desc = "Grep (cwd)", remap = true },
      { "<leader>bf", function() Snacks.picker.buffers({ layout = { preview = false, layout = vertical_layout }}) end, desc = "Buffers" },
      { "<leader>bF", function() Snacks.picker.buffers({ hidden = true, nofile = true, layout = { preview = false, layout = vertical_layout } }) end, desc = "Buffers (all)" },
      { "<leader>fF", LazyVim.pick("files", { layout = { preview = false, layout = vertical_layout } }), desc = "Find Files (Root Dir)" },
      { "<leader>ff", LazyVim.pick("files", { root = false, layout = { preview = false, layout = vertical_layout } }), desc = "Find Files (cwd)" },
      { "<leader><space>", "<leader>ff", desc = "Find Files (Root Dir)", remap = true },
      -- { "<leader>ff", LazyVim.pick("smart", { filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }), desc = "Find Files (Root Dir)" },
      -- { "<leader>fF", LazyVim.pick("smart", { filter = { cwd = true }, root = false, layout = { preview = false, layout = vertical_layout } }), desc = "Find Files" },
      { "<leader>fr", LazyVim.pick("oldfiles", { filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }), desc = "Recent (Root Dir)" },
      { "<leader>fR", LazyVim.pick("oldfiles", { root = false, filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }), desc = "Recent" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      if LazyVim.has_extra("editor.snacks_picker") == false then
        return
      end
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()
      vim.list_extend(Keys, {
        {
          "gd",
          function()
            Snacks.picker.lsp_definitions({
              layout = { preview = true, layout = vertical_layout },
            })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
        {
          "gr",
          function()
            Snacks.picker.lsp_references({
              layout = { preview = true, layout = vertical_layout },
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
              layout = { preview = true, layout = vertical_layout },
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
}
