return {
  -- override
  {
    "folke/flash.nvim",
    enabled = false,
    -- keys = {
    --   { "s", false },
    --   { "S", false },
    --   {
    --     "m",
    --     mode = { "n", "x", "o" },
    --     function()
    --       require("flash").jump()
    --     end,
    --     desc = "Flash",
    --   },
    --   {
    --     "M",
    --     mode = { "n", "o", "x" },
    --     function()
    --       require("flash").treesitter()
    --     end,
    --     desc = "Flash Treesitter",
    --   },
    -- },
  },
  {
    "echasnovski/mini.surround",
    enabled = false,
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
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    opts = {
      defaults = {
        results_title = false,
        sorting_strategy = "ascending",
        layout_strategy = "center",
        layout_config = {
          preview_cutoff = 1, -- Preview should always show (unless previewer = false)
          width = function(_, max_columns, _)
            return math.min(max_columns, 84)
          end,
          height = function(_, _, max_lines)
            return math.min(max_lines, 16)
          end,
        },
        -- border = true,
        -- borderchars = {
        --   prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
        --   results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
        --   preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        -- },
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

      -- overrides

      opts.window = {
        completion = cmp.config.window.bordered({
          side_padding = 0, -- to prevent icons from being cut off
        }),
        documentation = cmp.config.window.bordered(),
      }

      -- disable preselecting first item in completion menu
      -- opts.preselect = "None"
      -- opts.completion.completeopt = "menu,menuone,noselect,noinsert"

      opts.formatting = {
        fields = { "kind", "abbr", "menu" }, -- order of fields
        format = function(entry, item)
          local icons = require("lazyvim.config").icons.kinds

          local max_width = 26
          local max_detail_width = 20

          local source_name = ({
            nvim_lsp = "(LSP)",
            emoji = "(Emoji)",
            path = "(Path)",
            calc = "(Calc)",
            cmp_tabnine = "(Tabnine)",
            vsnip = "(Snippet)",
            luasnip = "(Snippet)",
            buffer = "(Buffer)",
            tmux = "(TMUX)",
            copilot = "(Copilot)",
            treesitter = "(TreeSitter)",
          })[entry.source.name]

          local detail = string.sub(entry.completion_item.detail or "", 1, max_detail_width)
          item.menu = string.format("%s %s", source_name, detail)

          if icons[item.kind] then
            item.kind = icons[item.kind]
            -- item.kind = icons[item.kind] .. item.kind
          end

          if max_width ~= 0 and #item.abbr > max_width then
            item.abbr = string.sub(item.abbr, 1, max_width - 1) .. "⋯"
          end

          return item
        end,
      }
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      stages = "fade",
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
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
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
