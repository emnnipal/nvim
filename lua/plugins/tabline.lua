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
}
