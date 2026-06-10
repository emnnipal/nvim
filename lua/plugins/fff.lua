return {
  {
    "dmtrKovalenko/fff.nvim",
    enabled = true,
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      prompt = "> ",
      layout = {
        height = 0.70,
        width = function(cols)
          return math.min(110 / cols, 0.95)
        end,
        preview_position = "top",
        preview_size = 0.6,
        prompt_position = "top",
        anchor = "center",
        flex = nil,
        path_shorten_strategy = "middle_number",
      },
      preview = {
        enabled = true,
      },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("fff").find_files({ preview = { enabled = false }, title = "Find Files" })
        end,
        desc = "Open file picker",
      },
    },
  },
}
