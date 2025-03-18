return {
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      -- TODO: remove
      -- {
      --   "L3MON4D3/LuaSnip",
      --   build = (function()
      --     -- Build Step is needed for regex support in snippets.
      --     -- This step is not supported in many windows environments.
      --     -- Remove the below condition to re-enable on windows.
      --     if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
      --       return
      --     end
      --     return "make install_jsregexp"
      --   end)(),
      --   dependencies = {
      --     -- `friendly-snippets` contains a variety of premade snippets.
      --     --    See the README about individual language/framework/plugin snippets:
      --     --    https://github.com/rafamadriz/friendly-snippets
      --     -- {
      --     --   'rafamadriz/friendly-snippets',
      --     --   config = function()
      --     --     require('luasnip.loaders.from_vscode').lazy_load()
      --     --   end,
      --     -- },
      --   },
      -- },
      -- TODO: remove
      -- "saadparwaiz1/cmp_luasnip",

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    config = function()
      -- See `:help cmp`
      local cmp = require("cmp")
      -- TODO: remove
      -- local luasnip = require("luasnip")
      -- luasnip.config.setup({})

      cmp.setup({
        -- TODO: remove
        -- snippet = {
        --   expand = function(args)
        --     luasnip.lsp_expand(args.body)
        --   end,
        -- },
        completion = { completeopt = "menu,menuone,noinsert" },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          -- ["<C-l>"] = cmp.mapping(function()
          --   if luasnip.expand_or_locally_jumpable() then
          --     luasnip.expand_or_jump()
          --   end
          -- end, { "i", "s" }),
          -- ["<C-h>"] = cmp.mapping(function()
          --   if luasnip.locally_jumpable(-1) then
          --     luasnip.jump(-1)
          --   end
          -- end, { "i", "s" }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        }),
        sources = {
          {
            name = "lazydev",
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = "nvim_lsp" },
          { name = "path" },
          -- { name = "nvim_lsp_signature_help" },
        },
        matching = {
          disallow_fuzzy_matching = true,
          disallow_fullfuzzy_matching = true,
          disallow_partial_fuzzy_matching = true,
          disallow_partial_matching = false,
          disallow_prefix_unmatching = false,
          disallow_symbol_nonprefix_matching = true,
        },
        window = {
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
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
        },
        performance = {
          -- defaults
          -- debounce = 60,
          throttle = 30,
          fetching_timeout = 500,
          filtering_context_budget = 3,
          confirm_resolve_timeout = 80,
          async_budget = 1,
          -- max_view_entries = 200,

          debounce = 20,
          max_view_entries = 50,
        },
      })
    end,
  },
}
