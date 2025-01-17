return {
  {
    "hrsh7th/nvim-cmp",
    enabled = LazyVim.has_extra("coding.nvim-cmp"),
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- super tab config
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      -- end of supertab config

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        -- { name = "luasnip" }, -- For luasnip users.
      }, {
        -- { name = "buffer" }, -- buffer words
      })

      -- enhance matching by reducing unnecessary completion results
      opts.matching = {
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
        disallow_symbol_nonprefix_matching = true,
      }

      opts.window = {
        documentation = cmp.config.window.bordered(),
      }

      -- looks like the default but with added completion item detail
      opts.formatting = {
        expandable_indicator = true,
        fields = { "abbr", "kind", "menu" }, -- order of fields
        format = function(entry, item)
          local max_label_width = 50
          local max_detail_width = 30

          local menu = item.menu
          if menu ~= nil and #menu > max_detail_width then
            item.menu = string.sub(menu or "", 1, max_detail_width)
          end

          -- local icons = LazyVim.config.icons.kinds
          -- if icons[item.kind] then
          --   item.kind = icons[item.kind] .. item.kind
          -- end

          if #item.abbr > max_label_width then
            item.abbr = string.sub(item.abbr, 1, max_label_width) .. "⋯"
          end

          return item
        end,
      }

      -- source: https://www.reddit.com/r/neovim/comments/1f1rxtx/share_a_tip_to_improve_your_experience_in_nvimcmp/
      -- defaults:
      -- performance = {
      --   debounce = 60,
      --   throttle = 30,
      --   fetching_timeout = 500,
      --   filtering_context_budget = 3,
      --   confirm_resolve_timeout = 80,
      --   async_budget = 1,
      --   max_view_entries = 200,
      -- }
      opts.performance = opts.performance or {}
      opts.performance.debounce = 10
      opts.performance.throttle = 10
      opts.performance.max_view_entries = 50
      opts.performance.fetching_timeout = 100 -- TODO: experimental
    end,
  },
  {
    "saghen/blink.cmp",
    enabled = LazyVim.has_extra("coding.blink"),
    -- version = "0.9.0", -- TODO: remove once latest version has fixed emmet-language-server issues
    opts = {
      sources = {
        providers = {
          snippets = {
            enabled = false,
          },
          buffer = {
            enabled = false,
          },
        },
      },
      completion = {
        list = {
          selection = { preselect = true, auto_insert = true }, -- TODO: comment this line if you're using version 0.9.0
        },
        menu = {
          draw = {
            treesitter = {},
            columns = { { "label", "kind", gap = 1 }, { "label_description" } },
            components = {
              label = {
                width = { max = 50 },
              },
            },
          },
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
        accept = { auto_brackets = { enabled = true } },
        ghost_text = {
          enabled = false,
        },
      },
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
    },
  },
}
