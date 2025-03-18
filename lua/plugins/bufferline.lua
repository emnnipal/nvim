return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        -- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icons = {
            error = "●",
            warning = "▲",
            hint = "󰛨 ",
            -- hint = "󰌶",
          }
          return icons[level] or "◉"
        end,
        indicator = {
          -- icon = "▎", -- this should be omitted if indicator style is not 'icon'
          -- style = "icon" | "underline" | "none",
          style = "none",
        },

        modified_icon = "●",
        -- this takes more space so ew use just an icon instead
        -- modified_icon = "[+]",

        always_show_bufferline = false,
        -- diagnostics_update_on_event = false,

        -- stylua: ignore
        close_command = function(n) Snacks.bufdelete(n) end,
        -- stylua: ignore
        right_mouse_command = function(n) Snacks.bufdelete(n) end,
        always_show_bufferline = false,
        -- NOTE: from lazyvim
        -- offsets = {
        --   {
        --     filetype = "neo-tree",
        --     text = "Neo-tree",
        --     highlight = "Directory",
        --     text_align = "left",
        --   },
        --   {
        --     filetype = "snacks_layout_box",
        --   },
        -- },
        -- ---@param opts bufferline.IconFetcherOpts
        -- get_element_icon = function(opts)
        --   return LazyVim.config.icons.ft[opts.filetype]
        -- end,
      },
    },
    keys = {
      {
        "<leader>bo",
        function()
          Snacks.bufdelete.other()
        end,
        desc = "Delete Other Buffers",
      },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
  },
}
