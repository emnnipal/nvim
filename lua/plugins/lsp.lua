return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- disable a keymap
      keys[#keys + 1] = { "K", false }

      -- TODO: disable show documentation/hover keymap with "K" in textDocument/hover
    end,
    opts = {
      -- autoformat = false, -- disable autoformat for lsp
      setup = {
        -- disable auto fix for eslint
        eslint = function() end,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        hover = {
          silent = true, -- set to true to not show a message if hover is not available
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Add your desired languages here to ensure they are installed
      vim.list_extend(opts.ensure_installed, { "svelte-language-server", "prisma-language-server" })
    end,
  },
}
