return {
  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      explorer = {
        enabled = LazyVim.has_extra("editor.snacks_explorer"),
        replace_netrw = true,
      },
      picker = {
        sources = {
          explorer = {
            auto_close = true,
            layout = {
              preset = "vertical",
              layout = {
                -- position = "float"
                width = 120,
              },
            },
            ---@diagnostic disable: missing-fields
            icons = {
              -- tree = {
              --   vertical = "│  ",
              --   middle = "├╴ ",
              --   last = "└╴ ",
              -- },
            },
          },
        },
      },
    },
  },
}
