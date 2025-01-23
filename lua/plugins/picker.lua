return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = LazyVim.has_extra("editor.telescope"),
    opts = {
      defaults = {
        results_title = false,
        sorting_strategy = "ascending",
        layout_strategy = "center",
        layout_config = {
          preview_cutoff = 1, -- Preview should always show (unless previewer = false)
          width = function(_, max_columns, _)
            return math.min(max_columns, 110)
          end,
          height = function(_, _, max_lines)
            return math.min(max_lines, 20)
          end,
        },
      },
    },
    keys = {
      { "<leader>s/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in current buffer" },
    },
  },

  {
    "ibhagwan/fzf-lua",
    enabled = LazyVim.has_extra("editor.fzf"),
    opts = {
      winopts_fn = function()
        return {
          width = vim.o.columns > 200 and 0.45 or 0.65,
        }
      end,
      winopts = {
        height = 0.75,
        row = 0.1,
        backdrop = 100,
        preview = {
          layout = "vertical",
          delay = 40,
          vertical = "up:55%",
        },
      },
    },
    keys = {
      { "<leader>s/", "<cmd>FzfLua grep_curbuf<cr>", desc = "Search in current buffer" },
    },
  },

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
        layout = {
          preview = false,
          layout = {
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
          },
        },
      },
    },
    keys = {
      { "<leader>ff", LazyVim.pick("smart", { filter = { cwd = true } }), desc = "Find Files (Root Dir)" },
      { "<leader>fF", LazyVim.pick("smart", { filter = { cwd = true }, root = false }), desc = "Find Files" },

      { "<leader>fr", LazyVim.pick("oldfiles", { filter = { cwd = true } }), desc = "Recent (Root Dir)" },
      { "<leader>fR", LazyVim.pick("oldfiles", { filter = { cwd = true }, root = false }), desc = "Recent" },

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
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gd", function() Snacks.picker.lsp_definitions({ layout = { preview = true } }) end, desc = "Goto Definition", has = "definition" },
        { "gr", function() Snacks.picker.lsp_references({ layout = { preview = true } }) end, nowait = true, desc = "References" },
        { "gI", function() Snacks.picker.lsp_implementations({ layout = { preview = true } }) end, desc = "Goto Implementation" },
        { "gy", function() Snacks.picker.lsp_type_definitions({ layout = {preview = true } }) end, desc = "Goto T[y]pe Definition" },
        { "<leader>ss", function() Snacks.picker.lsp_symbols({ layout = { preview = true } }) end, desc = "LSP Symbols", has = "documentSymbol" },
      })
    end,
  },

  {
    "stevearc/dressing.nvim",
    -- Enable regardless of chosen picker. Originally, this is only enabled for telescope extra.
    enabled = true,

    -- configuration is from telescope extra
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
}
