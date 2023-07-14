return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- disable a keymap
      keys[#keys + 1] = { "K", false }
    end,
    opts = {
      -- autoformat = false,
      setup = {
        -- disable auto fix for eslint
        eslint = function() end,
        tailwindcss = function()
          require("lazyvim.util").on_attach(function(client, bufnr)
            if client.name == "tailwindcss" then
              local tw_highlight = require("tailwind-highlight")
              tw_highlight.setup(client, bufnr, {
                single_column = false,
                mode = "background",
                debounce = 200,
              })
            end
          end)
        end,
      },
    },
  },
}
