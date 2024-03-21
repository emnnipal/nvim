return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_a = {
        {
          "mode",
          color = {
            bg = "none",
            fg = "#c8d3f5",
            gui = "none",
          },
        },
      }

      opts.sections.lualine_b = {}
      opts.sections.lualine_x = {
        {
          function()
            local buf_clients = vim.lsp.get_active_clients({ bufnr = 0 })
            if #buf_clients == 0 then
              return "LSP Inactive"
            end

            local buf_client_names = {}

            for _, client in pairs(buf_clients) do
              if client.name ~= "null-ls" and client.name ~= "copilot" then
                table.insert(buf_client_names, client.name)
              end
            end

            local unique_client_names = table.concat(buf_client_names, ", ")
            local language_servers = string.format("[%s]", unique_client_names)

            return language_servers
          end,
        },
      }

      opts.sections.lualine_y = {}
      opts.sections.lualine_z = {}
    end,
  },
  {
    "echasnovski/mini.indentscope",
    enabled = false,
  },
}
