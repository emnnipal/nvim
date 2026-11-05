-- LSP servers that should do the formatting when attached to the buffer. When one is attached,
-- conform formats with that server only (not the CLI formatters, not other LSPs).
-- Filled from `opts.lsp_formatters`, which other plugin files can add to (e.g. oxc.lua adds "oxfmt").
local lsp_formatters = {}

-- Returns the first server from `lsp_formatters` that is attached to the buffer, or nil.
local function preferred_lsp_formatter(bufnr)
  for _, name in ipairs(lsp_formatters) do
    if #vim.lsp.get_clients({ bufnr = bufnr, name = name }) > 0 then
      return name
    end
  end
end

return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    -- Merge `lsp_formatters` lists from all conform specs instead of replacing them.
    opts_extend = { "lsp_formatters" },
    config = function(_, opts)
      lsp_formatters = opts.lsp_formatters or {}
      -- Our own key, not a conform option: remove it before passing opts to conform.
      opts.lsp_formatters = nil
      require("conform").setup(opts)
    end,
    keys = {
      {
        "<leader>cf",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          -- e.g. "oxfmt" in an oxfmt project: format with that LSP only
          local name = preferred_lsp_formatter(bufnr)
          require("conform").format({
            bufnr = bufnr,
            async = true,
            lsp_format = name and "prefer" or "fallback",
            name = name,
          })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      lsp_formatters = {},
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          -- e.g. "oxfmt" in an oxfmt project: format with that LSP only
          local name = preferred_lsp_formatter(bufnr)
          if name then
            return { timeout_ms = 500, lsp_format = "prefer", name = name }
          end
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
      formatters = {
        -- injected = { options = { ignore_errors = true } },
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        --
        -- # Example of using shfmt with extra args
        -- shfmt = {
        --   prepend_args = { "-i", "2", "-ci" },
        -- },
      },
    },
  },
}
