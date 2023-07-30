return {
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      on_highlights = function(highlights)
        -- highlights.Comment = {
        --   fg = "#5c6691",
        --   style = "italic",
        -- }
        highlights.LineNr = {
          fg = "#4e557b",
        }
        highlights.CursorLineNr = {
          fg = "#9aa5ce",
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-storm",
    },
  },
  {
    "catppuccin/nvim",
    enabled = false,
  },
}
