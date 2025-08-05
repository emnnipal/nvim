return {
  {
    "nvim-telescope/telescope.nvim",
    enabled = vim.g.picker_plugin == "telescope",
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
}
