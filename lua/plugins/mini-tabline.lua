local color = require("core.color")

local function update_mini_tabline_colors()
  local bg = vim.api.nvim_get_hl(0, { name = "Normal" })
  local comment = vim.api.nvim_get_hl(0, { name = "Comment" })
  local darker_comment = color.darken(color.to_hex(comment.fg), 0.3)

  local is_light_theme = vim.o.background == "light"

  local darker_bg = color.darken(color.to_hex(bg.bg), 0.15)

  -- New color for modified buffers (use Statement or a brighter variant of comment)
  local string_color = vim.api.nvim_get_hl(0, { name = "String" })
  local modified_fg = is_light_theme and color.darken(color.to_hex(string_color.fg), 0.1)
    or color.to_hex(string_color.fg)

  vim.api.nvim_set_hl(0, "MiniTablineCurrent", {
    bg = bg.bg,
    fg = bg.fg,
    bold = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineVisible", {
    bg = darker_bg,
    fg = is_light_theme and darker_comment or comment.fg,
  })

  vim.api.nvim_set_hl(0, "MiniTablineHidden", {
    bg = darker_bg,
    fg = is_light_theme and darker_comment or comment.fg,
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedCurrent", {
    bg = bg.bg,
    fg = modified_fg, -- Different color for modified current
    bold = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedVisible", {
    bg = darker_bg,
    fg = modified_fg, -- Different color for modified visible
  })

  vim.api.nvim_set_hl(0, "MiniTablineModifiedHidden", {
    bg = darker_bg,
    fg = color.darken(modified_fg, 0.3), -- Darker version for modified hidden
    bold = true,
  })

  vim.api.nvim_set_hl(0, "MiniTablineFill", {
    bg = darker_bg,
  })

  vim.api.nvim_set_hl(0, "MiniTablineTrunc", {
    bg = darker_bg,
    fg = is_light_theme and darker_comment or comment.fg,
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
        local padding = " "
        return padding .. MiniTabline.default_format(buf_id, label) .. modified_indicator .. padding
      end,
    },
    config = function(_, opts)
      require("mini.tabline").setup(opts)

      vim.api.nvim_create_user_command("BuffDeleteLeft", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buffers = vim.api.nvim_list_bufs()

        for _, buf in ipairs(buffers) do
          if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and buf < current_buf then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end, {})

      vim.api.nvim_create_user_command("BuffDeleteRight", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buffers = vim.api.nvim_list_bufs()

        for _, buf in ipairs(buffers) do
          if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and buf > current_buf then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end, {})

      vim.api.nvim_create_user_command("BuffDeleteOthers", function()
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
      { "<leader>bo", "<cmd>BuffDeleteOthers<CR>", desc = "Close Other Buffers" },

      { "<leader>qc", "<leader>bd", desc = "Close Buffer", remap = true },
      { "<leader>bp", "<leader>j", desc = "Previous Buffer", remap = true },
      { "<leader>bn", "<leader>k", desc = "Next Buffer", remap = true },

      { "<leader>bh", "<CMD>BuffDeleteLeft<CR>", desc = "Close Buffers to the Left" },
      { "<leader>bl", "<CMD>BuffDeleteRight<CR>", desc = "Close Buffers to the Right" },
    },
  },
}
