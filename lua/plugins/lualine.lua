-- local M = {}
--
-- _G._statusline = M
--
-- local counter = 0
-- function M.diagnostic_status()
--   local ok = ""
--
--   local ignore = {
--     ["c"] = true, -- command mode
--     ["t"] = true, -- terminal mode
--   }
--
--   local mode = vim.api.nvim_get_mode().mode
--
--   if ignore[mode] then
--     return ok
--   end
--
--   local levels = vim.diagnostic.severity
--   local errors = #vim.diagnostic.get(0, { severity = levels.ERROR })
--   if errors > 0 then
--     return " ✘ "
--   end
--
--   local warnings = #vim.diagnostic.get(0, { severity = levels.WARN })
--   if warnings > 0 then
--     return " ▲ "
--   end
--
--   return ok
-- end
--
-- function M.active_lsp()
--   local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
--   if #buf_clients == 0 then
--     return "LSP Inactive"
--   end
--
--   local buf_client_names = {}
--
--   for _, client in pairs(buf_clients) do
--     table.insert(buf_client_names, client.name)
--   end
--
--   local unique_client_names = table.concat(buf_client_names, ", ")
--   local language_servers = string.format("[%s]", unique_client_names)
--
--   return language_servers
-- end
--
-- local modes = {
--   n = "NORMAL",
--   i = "INSERT",
--   v = "VISUAL",
--   V = "V-LINE",
--   c = "COMMAND",
--   R = "REPLACE",
--   s = "SELECT",
--   t = "TERMINAL",
-- }
--
-- function M.display_mode()
--   local current_mode = vim.api.nvim_get_mode().mode
--   return modes[current_mode] or current_mode
-- end
--
-- local statusline = {
--   " %{%v:lua._statusline.display_mode()%} ",
--   '%{expand("%:~:.")}', -- show current buffer file path relative to cwd
--   "%r",
--   "%m",
--   -- " - %{&filetype} ",
--   "%=",
--   "%{%v:lua._statusline.diagnostic_status()%}",
--   "%{%v:lua._statusline.active_lsp()%}",
--   -- " %2p%% ", -- show line position in percentage
--   -- " %3l:%-2c ", -- show cursor position in column and row number
--   -- '%{%v:lua._statusline_component("position")%}',
-- }
--
-- vim.o.statusline = table.concat(statusline, "")

return {
  {
    "nvim-lualine/lualine.nvim",
    -- enabled = false,
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons

      -- Do not show lualine when using neo-tree.
      opts.options.ignore_focus = opts.options.ignore_focus or {}
      table.insert(opts.options.ignore_focus, "neo-tree")

      opts.sections = {
        lualine_a = {
          {
            "mode",
            color = {
              bg = "none",
              fg = "#c8d3f5",
              gui = "none",
            },
          },
        },
        lualine_b = {},
        lualine_c = {
          vim.tbl_extend("force", LazyVim.lualine.root_dir(), { separator = "" }),
          { LazyVim.lualine.pretty_path() },
        },
        lualine_x = {
          -- { -- Displays the status if you are recording macros.
          --   function()
          --     return require("noice").api.status.mode.get()
          --   end,
          --   cond = function()
          --     return package.loaded["noice"] and require("noice").api.status.mode.has()
          --   end,
          --   color = function()
          --     return { fg = Snacks.util.color("Constant") }
          --   end,
          --   separator = "",
          -- },

          {
            "diagnostics",
            separator = "",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },

          {
            function()
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              if #buf_clients == 0 then
                return "LSP Inactive"
              end

              local buf_client_names = {}

              for _, client in pairs(buf_clients) do
                table.insert(buf_client_names, client.name)
              end

              local unique_client_names = table.concat(buf_client_names, ", ")
              local language_servers = string.format("[%s]", unique_client_names)

              return language_servers
            end,
          },
        },
        lualine_y = {},
        lualine_z = {},
      }
    end,
  },
}
