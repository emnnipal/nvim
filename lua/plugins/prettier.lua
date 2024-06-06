-- TODO: remove once prettierd is again the one used as formatter instead of prettier

if lazyvim_docs then
  -- By default, prettier will only be used for formatting
  -- if a prettier configuration file is found in the project.
  -- Set to `false` to always use prettier for supported filetypes.
  vim.g.lazyvim_prettier_needs_config = true
end

local needs_config = vim.g.lazyvim_prettier_needs_config ~= false

-- local check = vim.g.lazyvim_prettier

local enabled = {} ---@type table<string, boolean>
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "prettierd")
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      table.insert(opts.sources, nls.builtins.formatting.prettierd)
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettierd" },
        ["javascriptreact"] = { "prettierd" },
        ["typescript"] = { "prettierd" },
        ["typescriptreact"] = { "prettierd" },
        ["vue"] = { "prettierd" },
        ["css"] = { "prettierd" },
        ["scss"] = { "prettierd" },
        ["less"] = { "prettierd" },
        ["html"] = { "prettierd" },
        ["json"] = { "prettierd" },
        ["jsonc"] = { "prettierd" },
        ["yaml"] = { "prettierd" },
        ["markdown"] = { "prettierd" },
        ["markdown.mdx"] = { "prettierd" },
        ["graphql"] = { "prettierd" },
        ["handlebars"] = { "prettierd" },
        ["svelte"] = { "prettierd" },
      },
      formatters = {
        prettier = {
          condition = function(_, ctx)
            if not needs_config then
              return true
            end
            if enabled[ctx.filename] == nil then
              enabled[ctx.filename] = vim.fs.find(function(name, path)
                return name:match("^%.prettierrc%.") or name:match("^prettier%.config%.")
              end, { path = ctx.filename, upward = true })[1] ~= nil
            end
            return enabled[ctx.filename]
          end,
        },
      },
    },
  },
}
