local fff_utils = require("config.fff-utils")

return {
  {
    "dmtrKovalenko/fff.nvim",
    enabled = vim.g.picker_plugin == "fff",
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      prompt = "> ",
      layout = {
        height = 0.74,
        width = function(cols)
          return math.min(110 / cols, 0.95)
        end,
        preview_position = "top",
        preview_size = 0.54,
        prompt_position = "top",
        anchor = "center",
        flex = nil,
        path_shorten_strategy = "middle_number",
      },
      preview = {
        enabled = true,
      },
      grep = {
        modes = { "fuzzy", "plain", "regex" },
      },
      hl = {
        matched = "FFFSearchMatch",
        grep_match = "FFFSearchMatch",
      },
    },
    config = function(_, opts)
      fff_utils.setup_highlights()
      require("fff").setup(opts)
      fff_utils.setup_autocmds()
    end,
    -- fff indexes with .gitignore/.ignore rules enabled. To search a specific
    -- ignored/hidden file (for example .env), de-ignore it in the project's
    -- .ignore file, then run :FFFScan:
    --   !.env
    --   !.env.*
    keys = {
      {
        "<leader>R",
        function()
          require("fff").resume()
        end,
        desc = "Resume Picker",
      },
      {
        "<leader>ff",
        function()
          require("fff").find_files({ preview = { enabled = false }, title = "Find Files" })
        end,
        desc = "Open file picker",
      },
      {
        "<leader><space>",
        function()
          require("fff").find_files({ preview = { enabled = false }, title = "Find Files" })
        end,
        desc = "Find Files",
      },
      {
        "<leader>sg",
        function()
          require("fff").live_grep({ title = "Grep" })
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>/",
        function()
          require("fff").live_grep({ title = "Grep" })
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>sw",
        function()
          fff_utils.live_grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      {
        "<leader>sW",
        function()
          fff_utils.live_grep_word({ cwd = vim.fn.getcwd() })
        end,
        desc = "Visual selection or word (cwd)",
        mode = { "n", "x" },
      },
    },
  },
}
