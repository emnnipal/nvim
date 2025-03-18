return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- indent = {
      --   scope = { enabled = false },
      -- },
      explorer = { enabled = false },
      input = {
        enabled = false,
        icon_pos = false,
        win = {
          title_pos = "left",
          width = 35,
          relative = "cursor",
          row = -3,
          col = 0,
        },
      },
      indent = { enabled = true, scope = { enabled = false } },
      picker = { enabled = true },

      notifier = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = false },
      toggle = { enabled = false },
      words = { enabled = false },

      bigfile = { enabled = false },
      dashboard = { enabled = true },
      quickfile = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          -- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          -- Snacks.toggle.diagnostics():map("<leader>ud")
          -- Snacks.toggle.line_number():map("<leader>ul")
          -- Snacks.toggle
          --   .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          --   :map("<leader>uc")
          -- Snacks.toggle.treesitter():map("<leader>uT")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          -- Snacks.toggle.inlay_hints():map("<leader>uh")
          -- Snacks.toggle.indent():map("<leader>ug")
          -- Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },

  -- {
  --   "snacks.nvim",
  --   ---@module 'snacks'
  --   ---@type snacks.Config
  --   ---@diagnostic disable-next-line: missing-fields
  --   opts = {
  --     explorer = {
  --       enabled = LazyVim.has_extra("editor.snacks_explorer"),
  --       replace_netrw = true,
  --     },
  --     picker = {
  --       sources = {
  --         explorer = {
  --           auto_close = true,
  --           layout = {
  --             preset = "vertical",
  --             layout = {
  --               -- position = "float"
  --               width = 120,
  --             },
  --           },
  --           ---@diagnostic disable: missing-fields
  --           icons = {
  --             -- tree = {
  --             --   vertical = "│  ",
  --             --   middle = "├╴ ",
  --             --   last = "└╴ ",
  --             -- },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
