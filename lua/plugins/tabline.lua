local color = require("core.color")

local function update_mini_tabline_colors()
  local bg = vim.api.nvim_get_hl(0, { name = "Normal" })
  local comment = vim.api.nvim_get_hl(0, { name = "Comment" })
  local statement = vim.api.nvim_get_hl(0, { name = "Statement" }) -- For modified icon

  -- Darken current background by 20% for the tabline background
  local darker_bg = color.darken(color.to_hex(bg.bg), 0.2)

  vim.api.nvim_set_hl(0, "MiniTablineCurrent", {
    bg = bg.bg,
    fg = bg.fg, -- Active buffer with Normal text color (same as before)
    bold = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineVisible", {
    bg = darker_bg,
    fg = comment.fg, -- Inactive visible buffers (Comment color)
  })

  vim.api.nvim_set_hl(0, "MiniTablineHidden", {
    bg = darker_bg,
    fg = comment.fg, -- Hidden buffers with the same Comment color
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
    bg = bg.bg,
    fg = bg.fg,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", {
    bg = darker_bg,
    fg = statement.fg,
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
    bg = darker_bg,
    fg = comment.fg,
    bold = true,
    italic = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineFill", {
    bg = darker_bg,
  })
  vim.api.nvim_set_hl(0, "MiniTablineTrunc", {
    bg = darker_bg,
    fg = comment.fg,
  })
end

-- Run on startup and when changing themes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = update_mini_tabline_colors,
})

-- Update colors on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    update_mini_tabline_colors()
  end,
})

return {
  {
    "echasnovski/mini.tabline",
    version = false,
    event = "BufReadPre",
    opts = {
      show_icons = false,
      format = function(buf_id, label)
        local modified_indicator = vim.bo[buf_id].modified and "+ " or ""
        return MiniTabline.default_format(buf_id, label) .. modified_indicator
      end,
    },
    config = function(_, opts)
      require("mini.tabline").setup(opts)

      vim.api.nvim_create_user_command("BDeleteLeft", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buffers = vim.api.nvim_list_bufs()

        for _, buf in ipairs(buffers) do
          if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and buf < current_buf then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end, {})

      vim.api.nvim_create_user_command("BDeleteRight", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buffers = vim.api.nvim_list_bufs()

        for _, buf in ipairs(buffers) do
          if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and buf > current_buf then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end, {})

      vim.api.nvim_create_user_command("BdeleteOthers", function()
        local current_buf = vim.api.nvim_get_current_buf()

        -- Get all listed buffers
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          -- Skip the current buffer and only delete listed, valid buffers
          if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
            vim.api.nvim_buf_delete(buf, { force = false })
          end
        end
      end, { desc = "Delete all buffers except the current one" })
    end,
    keys = {
      { "<leader>j", "<CMD>bprevious<CR>", { desc = "Previous Buffer" } },
      { "<leader>k", "<CMD>bnext<CR>", { desc = "Next Buffer" } },
      { "<leader>bd", "<CMD>bdelete<CR>", desc = "Close Buffer" },
      { "<leader>qc", "<leader>bd", desc = "Close Buffer", remap = true },
      { "<leader>bp", "<leader>j", desc = "Previous Buffer", remap = true },
      { "<leader>bn", "<leader>k", desc = "Next Buffer", remap = true },
      { "<leader>bo", "<cmd>BdeleteOthers<CR>", desc = "Close Other Buffers" },

      { "<leader>bh", "<CMD>BDeleteLeft<CR>", desc = "Close Buffers to the Left" },
      { "<leader>bl", "<CMD>BDeleteRight<CR>", desc = "Close Buffers to the Right" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    enabled = false,
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
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>j", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
      { "<leader>k", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Close Buffer" },
      { "<leader>qc", "<leader>bd",  desc = "Close Buffer", remap = true },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete Non-Pinned Buffers" },
      { "<leader>bl", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete Buffers to the Right" },
      { "<leader>bh", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
  },
}
