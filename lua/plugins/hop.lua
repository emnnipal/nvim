return {
  {
    "folke/flash.nvim",
    enabled = false,
  },

  {
    "smoka7/hop.nvim",
    event = "BufReadPre",
    config = function()
      local hop = require("hop")
      hop.setup()
      vim.keymap.set("n", "m", function()
        hop.hint_words()
      end, { remap = true, desc = "Hop" })
    end,
  },
}
