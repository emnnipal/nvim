return {
  {
    "dmtrKovalenko/fff.nvim",
    build = "cargo build --release",
    enabled = false,
    opts = {},
    keys = {
      {
        "<leader>ff",
        function()
          require("fff").find_files()
        end,
        desc = "Open file picker",
      },
    },
  },
}
