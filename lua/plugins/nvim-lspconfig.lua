return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "eslint" }, -- NOTE: if you use mason-tool-installer, set this to empty table {}
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      { "j-hui/fidget.nvim", opts = {} },
      { "mason-org/mason-lspconfig.nvim" },
    },
    opts = {
      inlay_hints = { enabled = false },
      -- autoformat = false, -- disable autoformat for lsp
      -- NOTE: ensure only LSP servers are installed here, mason.nvim handles formatters
      servers = {},
      setup = {},
    },
    config = function(_, opts)
      local lspConfigPath = require("lazy.core.config").options.root .. "/nvim-lspconfig"
      -- INFO: `prepend` ensures it is loaded before the user's LSP configs, so
      -- that the user's configs override nvim-lspconfig.
      vim.opt.runtimepath:prepend(lspConfigPath)
    end,
  },
}
