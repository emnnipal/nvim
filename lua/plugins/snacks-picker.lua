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
            filename_first = true,
            truncate = 104, -- truncate the file path to (roughly) this length
          },
        },
        previewers = {
          git = {
            builtin = false, -- use Neovim for previewing git output (true) or use git (false)
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

      { "<leader>fb", function() Snacks.picker.buffers({ layout = { preview = false, layout = vertical_layout }}) end, desc = "Buffers" },
      { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true, layout = { preview = false, layout = vertical_layout } }) end, desc = "Buffers (all)" },

      { "<leader>ff", function() Snacks.picker.smart({ filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }) end, desc = "Smart Find Files" },
      -- { "<leader>ff",function() Snacks.picker.files({ layout = { preview = false, layout = vertical_layout } }) end, desc = "Find Files (cwd)" },

      { "<leader><space>", "<leader>ff", desc = "Smart Find Files", remap = true },
      -- { "<leader><space>", function() Snacks.picker.smart({ filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }) end, desc = "Smart Find Files" },

      { "<leader>fr",function() Snacks.picker.recent({ filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }) end, desc = "Recent (cwd)" },
      { "<leader>fR",function() Snacks.picker.recent({ layout = { preview = false, layout = vertical_layout } }) end, desc = "Recent (all)" },

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
      { "<leader>sw", function() Snacks.picker.grep_word({ layout = { preview = true , layout= vertical_layout } }) end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>sW", function() Snacks.picker.grep_word({ root = false,  layout = { preview = true , layout= vertical_layout } }) end, desc = "Visual selection or word", mode = { "n", "x" } },

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
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Use Recent Picker" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
      -- ui
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function()
      if vim.g.picker_plugin ~= "snacks" then
        return
      end

      local keymap = require("core.keymaps")
      keymap.extend_keymaps({
        {
          "gd",
          function()
            Snacks.picker.lsp_definitions({ layout = { preview = true, layout = vertical_layout } })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
        {
          "gr",
          function()
            Snacks.picker.lsp_references({ layout = { preview = true, layout = vertical_layout } })
          end,
          nowait = true,
          desc = "References",
        },
        {
          "<leader>ss",
          function()
            Snacks.picker.lsp_symbols({
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
