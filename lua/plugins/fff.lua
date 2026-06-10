local fff_utils = require("config.fff-utils")

---@type snacks.layout.Box
local snacks_vertical_layout = {
  backdrop = false,
  width = 110,
  height = 0.70,
  box = "vertical",
  border = "rounded",
  title = "{source} {live}",
  title_pos = "center",
  { win = "preview", height = 0.6, border = "bottom" },
  { win = "input", height = 1, border = "bottom" },
  { win = "list" },
}

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
    keys = {
      {
        "<leader>R",
        fff_utils.resume_picker,
        desc = "Resume Picker",
      },
      {
        "<leader>ff",
        function()
          fff_utils.open_picker("files", { preview = { enabled = false }, title = "Find Files" })
        end,
        desc = "Open file picker",
      },
      {
        "<leader><space>",
        function()
          fff_utils.open_picker("files", { preview = { enabled = false }, title = "Find Files" })
        end,
        desc = "Find Files",
      },
      {
        "<leader>sg",
        function()
          fff_utils.open_picker("grep", { title = "Grep" })
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>/",
        function()
          fff_utils.open_picker("grep", { title = "Grep" })
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>sw",
        function()
          fff_utils.live_grep_word()
        end,
        desc = "Visual selection or word",
      },
      {
        "<leader>sw",
        function()
          fff_utils.live_grep_word({ visual = true })
        end,
        desc = "Visual selection or word",
        mode = "x",
      },
      {
        "<leader>sW",
        function()
          fff_utils.live_grep_word({ cwd = vim.fn.getcwd() })
        end,
        desc = "Visual selection or word (cwd)",
      },
      {
        "<leader>sW",
        function()
          fff_utils.live_grep_word({ cwd = vim.fn.getcwd(), visual = true })
        end,
        desc = "Visual selection or word (cwd)",
        mode = "x",
      },
    },
  },

  {
    "folke/snacks.nvim",
    -- stylua: ignore
    keys = vim.g.picker_plugin == "fff" and {
      {
        "<leader>fF",
        function()
          fff_utils.open_snacks_picker(function()
            Snacks.picker.files({ hidden = true, ignored = true, layout = { preview = false, layout = snacks_vertical_layout } })
          end)
        end,
        desc = "Find Files (all)",
      },
      {
        "<leader>sG",
        function()
          fff_utils.open_snacks_picker(function()
            Snacks.picker.grep({ hidden = true, ignored = true, layout = { preview = true, layout = snacks_vertical_layout } })
          end)
        end,
        desc = "Grep (all)",
      },
    } or {},
  },
}
