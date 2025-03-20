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
        enabled = true,
        ui_select = true,
        formatters = {
          file = {
            -- filename_first = true,
            truncate = 90, -- truncate the file path to (roughly) this length
          },
        },
        win = {
          input = {
            keys = {
              ["<a-c>"] = {
                "toggle_cwd",
                mode = { "n", "i" },
              },
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>R", function() Snacks.picker.resume() end, desc = "Use Recent Picker" },

      { "<leader>sg",function() Snacks.picker.grep({ layout = { preview = true, layout = vertical_layout } }) end, desc = "Grep (cwd)" },
      { "<leader>/", "<leader>sg", desc = "Grep (cwd)", remap = true },

      -- TODO: remove if I no longer need it.
      -- TODO: open file picker based on root dir.
      -- { "<leader>sG",function() Snacks.picker.grep({ root = false, layout = { preview = true, layout = vertical_layout } }) end, desc = "Grep (cwd)" },
      -- { "<leader>sg",function() Snacks.picker.grep({ layout = { preview = true, layout = vertical_layout } }) end, desc = "Grep (Root Dir)" },
      -- { "<leader>/", "<leader>sG", desc = "Grep (cwd)", remap = true },

      { "<leader>fb", function() Snacks.picker.buffers({ layout = { preview = false, layout = vertical_layout }}) end, desc = "Buffers" },
      { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true, layout = { preview = false, layout = vertical_layout } }) end, desc = "Buffers (all)" },

      { "<leader>ff",function() Snacks.picker.files({ layout = { preview = false, layout = vertical_layout } }) end, desc = "Find Files (cwd)" },

      -- TODO: remove if I no longer need it.
      -- TODO: open file picker based on root dir.
      -- { "<leader>fF",function() Snacks.picker.files({ root = false, layout = { preview = false, layout = vertical_layout } }) end, desc = "Find Files (cwd)" },
      -- { "<leader>ff",function() Snacks.picker.files({ layout = { preview = false, layout = vertical_layout } }) end, desc = "Find Files (Root Dir)" },

      { "<leader><space>", "<leader>ff", desc = "Find Files (Root Dir)", remap = true },

      -- Smart picker
      -- { "<leader>ff", LazyVim.pick("smart", { filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }), desc = "Find Files (Root Dir)" },
      -- { "<leader>fF", LazyVim.pick("smart", { filter = { cwd = true }, root = false, layout = { preview = false, layout = vertical_layout } }), desc = "Find Files" },

      { "<leader>fr",function() Snacks.picker.recent({ filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }) end, desc = "Recent (cwd)" },
      { "<leader>fR",function() Snacks.picker.recent({ layout = { preview = false, layout = vertical_layout } }) end, desc = "Recent (all)" },


      -- TODO: remove unused
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- find
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- git
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      -- { "<leader>sw", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      -- { "<leader>sW", LazyVim.pick("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>sW", function() Snacks.picker.grep_word({ root = false }) end, desc = "Visual selection or word", mode = { "n", "x" } }, 

      -- search
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    },
  },

  -- TODO: dynamic setup in lsp config
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function()
  --     local Keys = require("config.lsp").keymaps()
  --     vim.list_extend(Keys, {
  --       {
  --         "gd",
  --         function()
  --           Snacks.picker.lsp_definitions({ layout = { preview = true, layout = vertical_layout } })
  --         end,
  --         desc = "Goto Definition",
  --         has = "definition",
  --       },
  --       {
  --         "gr",
  --         function()
  --           Snacks.picker.lsp_references({ layout = { preview = true, layout = vertical_layout } })
  --         end,
  --         nowait = true,
  --         desc = "References",
  --       },
  --       {
  --         "<leader>ss",
  --         function()
  --           Snacks.picker.lsp_symbols({
  --             -- filter = LazyVim.config.kind_filter,
  --             layout = { preview = true, layout = vertical_layout },
  --           })
  --         end,
  --         desc = "LSP Symbols",
  --         has = "documentSymbol",
  --       },
  --       {
  --         "<leader>sS",
  --         function()
  --           Snacks.picker.lsp_workspace_symbols({
  --             -- filter = LazyVim.config.kind_filter,
  --             layout = { preview = true, layout = vertical_layout },
  --           })
  --         end,
  --         desc = "LSP Workspace Symbols",
  --         has = "workspace/symbols",
  --       },
  --     })
  --   end,
  -- },

  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      if Utils.has("trouble.nvim") then
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = {
              trouble_open = function(...)
                return require("trouble.sources.snacks").actions.trouble_open.action(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end
    end,
  },

  {
    "folke/todo-comments.nvim",
    optional = true,
    -- stylua: ignore
    keys = {
      {
        "<leader>st",
        function() Snacks.picker.todo_comments({ layout = { preview = true, layout = vertical_layout } }) end,
        desc = "Todo",
      },
      {
        "<leader>sT",
        function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }, layout = { preview = true, layout = vertical_layout } }) end,
        desc = "Todo/Fix/Fixme",
      },
    },
  },
}
