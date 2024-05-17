return {
  -- disable plugins
  {
    "folke/flash.nvim",
    enabled = false,
  },

  -- override
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      scope = {
        enabled = false,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      views = {
        hover = {
          border = {
            padding = { 0, 0 },
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- disable some defaults
      opts.defaults["<leader>w"] = nil

      wk.register(opts.defaults)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        results_title = false,
        sorting_strategy = "ascending",
        layout_strategy = "center",
        layout_config = {
          preview_cutoff = 1, -- Preview should always show (unless previewer = false)
          width = function(_, max_columns, _)
            return math.min(max_columns, 98)
          end,
          height = function(_, _, max_lines)
            return math.min(max_lines, 15)
          end,
        },
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      -- super tab config
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        -- ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          -- elseif luasnip.expand_or_jumpable() then
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
      -- end of supertab config

      opts.sources = cmp.config.sources({
        { name = "nvim_lsp" },
        -- { name = "path" },
        -- { name = "luasnip" }, -- For luasnip users.
      }, {
        -- { name = "buffer" }, -- buffer words
      })

      opts.matching = {
        disallow_fuzzy_matching = true,
        disallow_fullfuzzy_matching = true,
        disallow_partial_fuzzy_matching = true,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
        disallow_symbol_nonprefix_matching = true,
      }

      opts.window = {
        -- completion = cmp.config.window.bordered({
        --   side_padding = 0,
        -- }),
        documentation = cmp.config.window.bordered(),
      }

      -- opts.formatting = {
      --   expandable_indicator = true,
      --   fields = { "kind", "abbr", "menu" }, -- order of fields
      --   format = function(entry, item)
      --     local icons = require("lazyvim.config").icons.kinds
      --
      --     local max_width = 26
      --     local max_detail_width = 20
      --
      --     local detail = string.sub(entry.completion_item.detail or "", 1, max_detail_width)
      --
      --     if #detail > 0 then
      --       -- double space to separate kind and detail
      --       item.menu = string.format("%s  %s", item.kind, detail)
      --     else
      --       item.menu = string.format("%s", item.kind)
      --     end
      --
      --     if icons[item.kind] then
      --       -- item.kind = string.gsub(icons[item.kind], "%s+", "") -- remove whitespace from icon
      --       item.kind = icons[item.kind]
      --       -- item.kind = icons[item.kind] .. item.kind
      --     end
      --
      --     if max_width ~= 0 and #item.abbr > max_width then
      --       item.abbr = string.sub(item.abbr, 1, max_width - 1) .. "⋯"
      --     end
      --
      --     return item
      --   end,
      -- }

      -- looks like the default but with added completion item detail
      opts.formatting = {
        expandable_indicator = true,
        fields = { "abbr", "kind", "menu" }, -- order of fields
        format = function(entry, item)
          local max_width = 28
          local max_detail_width = 20

          item.menu = string.sub(entry.completion_item.detail or "", 1, max_detail_width)

          -- local icons = LazyVim.config.icons.kinds
          -- if icons[item.kind] then
          --   item.kind = icons[item.kind] .. item.kind
          -- end

          if max_width ~= 0 and #item.abbr > max_width then
            item.abbr = string.sub(item.abbr, 1, max_width) .. "⋯"
          end

          return item
        end,
      }
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        win_options = {
          winblend = 0,
        },
      },
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
            "node_modules",
          },
          always_show = {
            ".env",
          },
        },
      },
    },
  },

  -- additional plugins
  {
    "Wansmer/treesj",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 1200,
    },
  },
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    opts = {},
  },
  {
    "f-person/git-blame.nvim",
    enabled = false, -- disable since I don't use it much
    event = "BufRead",
    config = function()
      vim.cmd("highlight default link gitblame SpecialComment")
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_message_when_not_committed = ""
      vim.g.gitblame_message_template = "  <author>, <date> • <sha> • <summary>"
      vim.g.gitblame_date_format = "%r"
    end,
  },
  {
    "mg979/vim-visual-multi",
    event = "BufReadPre",
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    opts = {
      default_mappings = false,
    },
  },
  {
    "phaazon/hop.nvim",
    event = "BufReadPre",
    config = function()
      local hop = require("hop")
      hop.setup()
      vim.keymap.set("", "m", function()
        hop.hint_words()
      end, { remap = true, desc = "Hop" })
    end,
  },
  -- buffer remove
  {
    "echasnovski/mini.bufremove", -- TODO: remove when all features of mini.bufremove are natively supported
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
}
