--- Returns a comparator that deprioritizes a specific CompletionItemKind
---@param kind number
---@return function
local function deprioritize_kind(kind)
  return function(entry1, entry2)
    local kind1 = entry1:get_kind() or 0
    local kind2 = entry2:get_kind() or 0

    if kind1 == kind2 then
      return nil
    end

    if kind1 == kind then
      return false
    elseif kind2 == kind then
      return true
    end

    return nil
  end
end

return {
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    enabled = vim.g.cmp_plugin == "nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local auto_select = true
      local compare = require("cmp.config.compare")
      local types = require("cmp.types")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
        },

        mapping = cmp.mapping.preset.insert({
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete({}),
        }),
        sources = {
          {
            name = "lazydev",
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = "nvim_lsp" },
          { name = "path" },
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
          -- defaults performance options
          -- debounce = 60,
          throttle = 30,
          fetching_timeout = 500,
          filtering_context_budget = 3,
          confirm_resolve_timeout = 80,
          async_budget = 1,
          -- max_view_entries = 200,

          -- custom performance options
          debounce = 20,
          max_view_entries = 50,
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            deprioritize_kind(types.lsp.CompletionItemKind.Text),

            -- default comparators from https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
            compare.offset,
            compare.exact,
            -- compare.scopes,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
      })
    end,
  },
}
