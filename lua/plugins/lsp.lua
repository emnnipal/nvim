return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- disable a keymap
      keys[#keys + 1] = { "K", false }
      -- LazyVim.lsp.on_attach(function()
      --   local border = "rounded"
      --
      --   vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      --     border = border,
      --   })
      --
      --   vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      --     border = border,
      --   })
      --
      --   vim.diagnostic.config({
      --     float = { border = border },
      --   })
      -- end)
    end,
    opts = {
      inlay_hints = { enabled = false },
      -- autoformat = false, -- disable autoformat for lsp
      -- setup = {
      --   -- disable auto fix for eslint
      --   eslint = function() end,
      -- },
      -- servers = {
      --   eslint = {
      --     settings = {
      --       -- This change in https://github.com/LazyVim/LazyVim/pull/2071 broke ESLint when
      --       -- working with mono repositories. To address this issue, I am fixing the change by adding this configuration.
      --       workingDirectory = { mode = "auto" },
      --     },
      --   },
      -- },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- Add your desired languages here to ensure they are installed
      vim.list_extend(opts.ensure_installed or {}, {
        "svelte-language-server",
        "prisma-language-server",
        "emmet-language-server",
        "css-lsp",
        "json-lsp",
        "bash-language-server",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add your desired syntax parsers here to ensure they are installed
      vim.list_extend(opts.ensure_installed, { "svelte", "prisma" })
    end,
  },
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
        hover = {
          -- enabled = false,
          silent = true, -- set to true to not show a message if hover is not available
        },
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
