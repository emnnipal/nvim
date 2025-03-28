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
        -- TODO: fix tailwindcss hover without noice.nvim. Noice is able to use markdown for highlighting css markdown when hovering tailwind classes.
        hover = {
          -- enabled = false,
          silent = true, -- set to true to not show a message if hover is not available
        },
        signature = {
          enabled = false,
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
