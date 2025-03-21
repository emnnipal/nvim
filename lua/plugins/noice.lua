return {
  {
    "folke/noice.nvim",
    -- enabled = false,
    opts = {
      cmdline = {
        enabled = false,
        view = "cmdline",
      },
      messages = {
        enabled = false,
      },
      lsp = {
        override = nil,
        progress = {
          enabled = false,
        },
        message = {
          -- Messages shown by lsp servers
          enabled = false,
        },
        -- TODO: recreate hover border feature without using experimental noice.nvim
        -- TODO: fix tailwindcss hover without noice.nvim. Without noice nvim, tailwind hover doesn't have treesitter.
        hover = {
          -- enabled = false,
          silent = true, -- set to true to not show a message if hover is not available
        },
        -- TODO: recreate signature help without noice.nvim
        signature = {
          -- enabled = true,
        },
      },
      presets = {
        lsp_doc_border = true,
      },
      popupmenu = {
        enabled = false,
      },
      notify = {
        enabled = false,
      },
      views = {
        hover = {
          border = {
            padding = { 0, 0 },
          },
        },
      },
    },
  },
}
