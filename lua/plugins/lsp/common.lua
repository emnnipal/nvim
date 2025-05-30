return {
  {
    "neovim/nvim-lspconfig",
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
      --       workingDirectory = { mode = "auto" },
      --     },
      --   },
      -- },
    },
  },
  {
    "mason-org/mason.nvim",
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
}
