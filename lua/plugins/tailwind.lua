return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes_exclude = { "markdown", "javascript", "typescript" },
        },
      },
      -- setup = {
      --   tailwindcss = function(_, opts)
      --     local tw = require("lspconfig.server_configurations.tailwindcss")
      --     --- @param ft string
      --     opts.filetypes = vim.tbl_filter(function(ft)
      --       return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
      --     end, tw.default_config.filetypes)
      --
      --     require("lazyvim.util").lsp.on_attach(function(client, bufnr)
      --       if client.name == "tailwindcss" then
      --         local tw_highlight = require("tailwind-highlight")
      --         tw_highlight.setup(client, bufnr, {
      --           single_column = false,
      --           mode = "background",
      --           debounce = 200,
      --         })
      --       end
      --     end)
      --   end,
      -- },
    },
  },
  -- {
  --   "princejoogie/tailwind-highlight.nvim",
  --   lazy = true,
  -- },
}
