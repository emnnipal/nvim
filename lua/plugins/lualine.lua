return {
  {
    "nvim-lualine/lualine.nvim",
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
          { -- Displays the status if you are recording macros.
            function()
              return require("noice").api.status.mode.get()
            end,
            cond = function()
              return package.loaded["noice"] and require("noice").api.status.mode.has()
            end,
            color = function()
              return { fg = Snacks.util.color("Constant") }
            end,
            separator = "",
          },

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
