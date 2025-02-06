return {
  -- floating neo-tree
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     window = {
  --       position = "float",
  --     },
  --     filesystem = {
  --       follow_current_file = {
  --         enabled = true,
  --         leave_dirs_open = true,
  --       },
  --     },
  --   },
  -- },

  {
    "snacks.nvim",
    ---@module 'snacks'
    ---@type snacks.Config
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
              -- layout = { position = "float" },
            },
          },
        },
      },
    },
  },
}
