return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = LazyVim.has_extra("editor.telescope"),
    opts = {
      defaults = {
        file_ignore_patterns = {
          "node_modules",
          "%.log",
          "pnpm%-lock.yaml",
          "yarn.lock",
          "package%-lock.json",
        },
        results_title = false,
        sorting_strategy = "ascending",
        layout_strategy = "center",
        layout_config = {
          preview_cutoff = 1, -- Preview should always show (unless previewer = false)
          width = function(_, max_columns, _)
            return math.min(max_columns, 110)
          end,
          height = function(_, _, max_lines)
            return math.min(max_lines, 18)
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
    "stevearc/dressing.nvim",
    -- Enable for fzf-lua as this is only enabled for telescope extra
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
