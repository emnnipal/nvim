return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  keys = {
    {
      "<leader>um",
      "<CMD>Markview<CR>",
      desc = "Toggle markdown preview",
    },
  },

  opts = {
    preview = {
      enable = false,
    },
  },

  -- Completion for `blink.cmp`
  -- dependencies = { "saghen/blink.cmp" },
}
