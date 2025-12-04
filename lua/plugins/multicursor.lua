return {
  {
    "jake-stewart/multicursor.nvim",
    -- stylua: ignore
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add or skip cursor above/below the main cursor.
      set({ "n", "x" }, "<A-k>", function() mc.lineAddCursor(-1) end, { desc = "Select cursor up" })
      set({ "n", "x" }, "<A-j>", function() mc.lineAddCursor(1) end, { desc = "Select cursor down" })
      set({ "n", "x" }, "<A-K>", function() mc.lineSkipCursor(-1) end, { desc = "Skip cursor up" })
      set({ "n", "x" }, "<A-J>", function() mc.lineSkipCursor(1) end, { desc = "Skip cursor down" })

      -- Add or skip adding a new cursor by matching word/selection
      set({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end, { desc = "Select cursor down by matching word" })
      set({ "n", "x" }, "<C-p>", function() mc.matchAddCursor(-1) end, { desc = "Select cursor up by matching word" })

      -- Add and remove cursors with control + left click.
      -- set("n", "<c-leftmouse>", mc.handleMouse)
      -- set("n", "<c-leftdrag>", mc.handleMouseDrag)
      -- set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      set({ "n", "x" }, "<C-q>", mc.toggleCursor, { desc = "Select cursor position" })

      -- Add a cursor for all matches of cursor word/selection in the document.
      set({"n", "x"}, "<leader>A", mc.matchAllAddCursors, { desc = "Add cursor to all matches"})

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Select a different cursor as the main one.
        -- layerSet({ "n", "x" }, "<left>", mc.prevCursor)
        -- layerSet({ "n", "x" }, "<right>", mc.nextCursor)

        layerSet({ "n", "x" }, "q", function() mc.matchSkipCursor(1) end, { desc = "Skip cursor down" })

        layerSet({ "n", "x" }, "Q", function() mc.matchSkipCursor(-1) end, { desc = "Skip cursor up" })

        layerSet({ "n", "x" }, "n", function() mc.matchAddCursor(1) end, { desc = "Select cursor down by matching word" })

        layerSet({ "n", "x" }, "N", function() mc.matchAddCursor(-1) end, { desc = "Select cursor up by matching word" })

        -- Delete the main cursor.
        layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor, { desc = "Remove current cursor" })

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      -- hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorCursor", { link = "IncSearch" })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },

  -- {
  --   "mg979/vim-visual-multi",
  --   event = "BufReadPre",
  --   init = function()
  --     vim.g.VM_maps = {
  --       ["I Return"] = "<S-CR>",
  --     }
  --   end,
  --   keys = {
  --     {
  --       "<A-k>",
  --       "<Plug>(VM-Add-Cursor-Up)",
  --       desc = "Select multi cursor up",
  --     },
  --     {
  --       "<A-j>",
  --       "<Plug>(VM-Add-Cursor-Down)",
  --       desc = "Select multi cursor down",
  --     },
  --   },
  -- },
}
