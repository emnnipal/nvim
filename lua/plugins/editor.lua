return {
  -- disable plugins
  {
    "folke/flash.nvim",
    enabled = false,
  },
  {
    "echasnovski/mini.ai",
    enabled = false,
  },
  {
    "ahmedkhalf/project.nvim",
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
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>w", "<Cmd>update<CR>", desc = "Write" },
        { "<leader>W", "<Cmd>noautocmd w<CR>", desc = "Save without formatting" },
      },
    },
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
            return math.min(max_columns, 110)
          end,
          height = function(_, _, max_lines)
            return math.min(max_lines, 18)
          end,
        },
      },
    },
    keys = {
      { "<leader>s/", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Search in current buffer" },
    },
  },
  {
    "ibhagwan/fzf-lua",
    opts = {
      winopts_fn = function()
        return {
          width = vim.o.columns > 200 and 0.45 or 0.65,
        }
      end,
      winopts = {
        height = 0.75,
        row = 0.1,
        backdrop = 100,
        preview = {
          layout = "vertical",
          delay = 50,
          vertical = "up:55%",
        },
      },
    },
    keys = {
      { "<leader>s/", "<cmd>FzfLua grep_curbuf<cr>", desc = "Search in current buffer" },
    },
  },
  { -- Enable for fzf-lua as this is only enabled for telescope extra
    "stevearc/dressing.nvim",
    enabled = true,
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
    end,
  },
  {
    "saghen/blink.cmp",
    enabled = false,
    opts = {
      sources = {
        completion = {
          enabled_providers = {
            "lsp",
            "path",
            -- "snippets",
            -- "buffer"
          },
        },
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
          selection = "preselect",
        },
        menu = {
          draw = {
            treesitter = false,
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
        accept = { auto_brackets = { enabled = true } }, -- TODO: remove once fixed in blink extra
      },
      keymap = {
        preset = "enter",
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
      },
    },
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
}
