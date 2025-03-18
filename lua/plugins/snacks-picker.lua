---@diagnostic disable: missing-fields, assign-type-mismatch

-- ---@type snacks.layout.Box
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
        ui_select = false,
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
      -- { "<leader>sg",  LazyVim.pick("live_grep", { layout = { preview = true, layout = vertical_layout } }), desc = "Grep (Root Dir)" },
      -- { "<leader>sG", LazyVim.pick("live_grep", { root = false, layout = { preview = true, layout = vertical_layout } }), desc = "Grep (cwd)" },
      { "<leader>sg",function() Snacks.picker.grep({ layout = { preview = true, layout = vertical_layout } }) end, desc = "Grep (Root Dir)" },
      { "<leader>sG",function() Snacks.picker.grep({ root = false, layout = { preview = true, layout = vertical_layout } }) end, desc = "Grep (cwd)" },
      { "<leader>/", "<leader>sG", desc = "Grep (cwd)", remap = true },
      { "<leader>fb", function() Snacks.picker.buffers({ layout = { preview = false, layout = vertical_layout }}) end, desc = "Buffers" },
      { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true, layout = { preview = false, layout = vertical_layout } }) end, desc = "Buffers (all)" },

      -- { "<leader>fF", LazyVim.pick("files", { layout = { preview = false, layout = vertical_layout } }), desc = "Find Files (Root Dir)" },
      -- { "<leader>ff", LazyVim.pick("files", { root = false, layout = { preview = false, layout = vertical_layout } }), desc = "Find Files (cwd)" },
      { "<leader>fF",function() Snacks.picker.files({ layout = { preview = false, layout = vertical_layout } }) end, desc = "Find Files (Root Dir)" },
      { "<leader>ff",function() Snacks.picker.files({ root = false, layout = { preview = false, layout = vertical_layout } }) end, desc = "Find Files (cwd)" },

      { "<leader><space>", "<leader>ff", desc = "Find Files (Root Dir)", remap = true },
      -- { "<leader>ff", LazyVim.pick("smart", { filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }), desc = "Find Files (Root Dir)" },
      -- { "<leader>fF", LazyVim.pick("smart", { filter = { cwd = true }, root = false, layout = { preview = false, layout = vertical_layout } }), desc = "Find Files" },

      -- TODO: remap
      -- { "<leader>fr", LazyVim.pick("oldfiles", { filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }), desc = "Recent (Root Dir)" },
      -- { "<leader>fR", LazyVim.pick("oldfiles", { root = false, filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }), desc = "Recent" },
      { "<leader>fr",function() Snacks.picker.recent({ filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }) end, desc = "Recent (Root Dir)" },
      { "<leader>fR",function() Snacks.picker.recent({ root = false, filter = { cwd = true }, layout = { preview = false, layout = vertical_layout } }) end, desc = "Recent" },


      -- TODO: remove unused
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- { "<leader>/", LazyVim.pick("grep"), desc = "Grep (Root Dir)" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- find
      -- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- { "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
      -- { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
      -- { "<leader>ff", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      -- { "<leader>fF", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Files (git-files)" },
      -- { "<leader>fr", LazyVim.pick("oldfiles"), desc = "Recent" },
      -- { "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- git
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      -- { "<leader>sg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      -- { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
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

  {
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("config.lsp").get()
      vim.list_extend(Keys, {
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
              -- filter = LazyVim.config.kind_filter,
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
              -- filter = LazyVim.config.kind_filter,
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
