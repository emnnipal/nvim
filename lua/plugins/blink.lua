if vim.g.cmp_plugin == "blink" then
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { link = "Comment" })
    end,
  })
end

return {
  {
    "saghen/blink.cmp",
    enabled = vim.g.cmp_plugin == "blink",
    event = "VimEnter",
    version = not vim.g.use_blink_main and "*" or nil,
    build = vim.g.use_blink_main and "cargo build --release" or nil,
    dependencies = {
      "folke/lazydev.nvim",
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },

      completion = {
        list = {
          max_items = 50,
          selection = { preselect = true, auto_insert = true },
        },
        menu = {
          draw = {
            treesitter = {},
            columns = { { "label", "kind", gap = 1 }, { "label_description" } },
            components = {
              label = {
                width = { max = 60 },
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
          },
        },
        accept = {
          auto_brackets = {
            enabled = false,
          },
        },
        ghost_text = {
          enabled = false,
        },
      },

      sources = {
        default = { "lsp", "path", "buffer" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },

      fuzzy = {
        implementation = "rust",
        -- sorts = function()
        --   local filetype = vim.bo.filetype
        --
        --   local emmet_file_map = {
        --     typescriptreact = true,
        --     javascriptreact = true,
        --   }
        --
        --   if emmet_file_map[filetype] then
        --     return {
        --       -- Uncomment if you're using emmet_language_server
        --       -- Deprioritize emmet lsp cmp items
        --       function(a, b)
        --         if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
        --           return
        --         end
        --         return b.client_name == "emmet_language_server"
        --       end,
        --
        --       "exact",
        --       "score",
        --       "sort_text",
        --     }
        --   end
        --
        --   return {
        --     "exact",
        --     "score",
        --     "sort_text",
        --   }
        -- end,
        sorts = {
          -- Uncomment if you're using emmet_language_server
          -- Deprioritize emmet lsp cmp items
          function(a, b)
            if (a.client_name == nil or b.client_name == nil) or (a.client_name == b.client_name) then
              return
            end
            return b.client_name == "emmet_language_server"
          end,

          "exact",
          "score",
          "sort_text",
        },
      },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = false },
      cmdline = { enabled = false },
    },
  },
}
