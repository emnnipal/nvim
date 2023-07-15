return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- disable a keymap
      keys[#keys + 1] = { "K", false }

      -- TODO: disable show documentation/hover keymap with "K" in textDocument/hover
      require("lazyvim.util").on_attach(function(_)
        local border = "rounded"

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = border,
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = border,
        })

        vim.diagnostic.config({
          float = { border = border },
        })
      end)
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
          enabled = false, -- disable noice for overriding hover
        },
        signature = {
          enabled = false, -- disable noice for overriding signature
        },
      },
    },
  },
}
