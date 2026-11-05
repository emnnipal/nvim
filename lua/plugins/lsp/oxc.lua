-- Auto-fix oxlint problems on save (only safe fixes, e.g. `let` -> `const`), before formatting.
-- Only applies to files where the oxlint LSP is attached.
vim.g.oxlint_fix_on_save = true

-- Asks the oxlint LSP to apply its fixes to the buffer, and waits until they are applied.
---@param bufnr integer
local function oxlint_fix_before_save(bufnr)
  -- Not an oxlint project (no oxlint LSP on this file): nothing to do.
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = "oxlint" })[1]
  if not client then
    return
  end
  -- Make oxlint lint the latest text first. Otherwise the fix uses old results
  -- and can miss what you just typed.
  if client.server_capabilities.diagnosticProvider then
    client:request_sync("textDocument/diagnostic", {
      textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    }, 500, bufnr)
  end
  -- Apply the fixes. request_sync waits, so the fixes are in the buffer before the file is written.
  client:request_sync("workspace/executeCommand", {
    command = "oxc.fixAll",
    arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
  }, 500, bufnr)
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        oxlint = {
          -- Only attach in projects with an oxlint config. nvim-lspconfig removed this,
          -- which made oxlint attach to every JS/TS file.
          workspace_required = true,
          -- When Neovim exits, wait up to 100 ms for the server to shut down, then kill it.
          -- Without this, the server is occasionally left running after Neovim exits.
          exit_timeout = 100,
          -- Our on_attach replaces nvim-lspconfig's, so recreate its :LspOxlintFixAll command.
          on_attach = function(client, bufnr)
            vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
              client:exec_cmd({
                title = "Apply Oxlint automatic fixes",
                command = "oxc.fixAll",
                arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
              })
            end, { desc = "Apply Oxlint automatic fixes" })
          end,
          keys = {
            { "<leader>ce", "<Cmd>LspOxlintFixAll<CR>", desc = "Fix oxlint errors" },
          },
        },
        -- oxfmt runs as an LSP so it stays running (no ~80 ms startup per save).
        -- conform formats through it when it's attached (see the conform spec below).
        oxfmt = {
          -- Only attach in projects with an oxfmt config (same reason as oxlint).
          workspace_required = true,
          -- Same as oxlint: don't leave the server running after Neovim exits.
          exit_timeout = 100,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      -- Format with the oxfmt LSP when it's attached (see lsp_formatters in conform.lua).
      opts.lsp_formatters = opts.lsp_formatters or {}
      table.insert(opts.lsp_formatters, "oxfmt")

      -- format_on_save runs on every save. Wrap the one from conform.lua so the oxlint fix
      -- runs first, then the original format_on_save does the formatting.
      local format_on_save = opts.format_on_save
      opts.format_on_save = function(bufnr)
        -- Step 1: lint fixes (only if enabled; does nothing without the oxlint LSP)
        if vim.g.oxlint_fix_on_save == true then
          oxlint_fix_before_save(bufnr)
        end
        -- Step 2: formatting (always)
        if type(format_on_save) == "function" then
          return format_on_save(bufnr)
        end
        return format_on_save
      end
    end,
  },
}
