-- Set to true to run `oxlint --fix` via conform on save (before oxfmt).
vim.g.oxlint_fix_on_save = false

local fix_on_save = vim.g.oxlint_fix_on_save == true

-- https://oxc.rs/docs/guide/usage/formatter
local oxfmt_supported = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
  "json5",
  "yaml",
  "toml",
  "html",
  "vue",
  "handlebars",
  "css",
  "scss",
  "less",
  "graphql",
  "markdown",
  "svelte",
}

-- Filetypes where oxlint --fix applies
local oxlint_supported = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "vue",
  "svelte",
  "astro",
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        oxlint = {
          keys = {
            { "<leader>ce", "<Cmd>LspOxlintFixAll<CR>", desc = "Fix oxlint errors" },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}

      -- oxlint goes first so lint fixes are applied before formatting
      if fix_on_save then
        for _, ft in ipairs(oxlint_supported) do
          opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
          table.insert(opts.formatters_by_ft[ft], "oxlint")
        end
      end

      for _, ft in ipairs(oxfmt_supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "oxfmt")
      end

      opts.formatters = opts.formatters or {}
      -- vite.config.* is intentionally excluded so plain Vite projects don't trigger oxfmt
      opts.formatters.oxfmt = {
        require_cwd = true,
        cwd = require("conform.util").root_file({ ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }),
      }
      opts.formatters.oxlint = {
        require_cwd = true,
        cwd = require("conform.util").root_file({ ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" }),
      }
    end,
  },
}
