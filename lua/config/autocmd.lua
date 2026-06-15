local function setup_yank_highlight()
  local current = vim.api.nvim_get_hl(0, { name = "YankHighlight", link = false })
  if current and current.bg then
    return
  end

  local incsearch = vim.api.nvim_get_hl(0, { name = "IncSearch", link = false })
  if incsearch and incsearch.bg then
    vim.g.yank_highlight_fg = incsearch.fg
    vim.g.yank_highlight_bg = incsearch.bg
  end

  if vim.g.yank_highlight_bg then
    vim.api.nvim_set_hl(0, "YankHighlight", { fg = vim.g.yank_highlight_fg, bg = vim.g.yank_highlight_bg })
  end
end

setup_yank_highlight()

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Refresh yank highlight colors",
  group = vim.api.nvim_create_augroup("nvim-yank-highlight-colors", { clear = true }),
  callback = function()
    vim.schedule(setup_yank_highlight)
  end,
})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("nvim-highlight-yank", { clear = true }),
  callback = function()
    setup_yank_highlight()
    vim.hl.on_yank({ higroup = "YankHighlight" })
  end,
})
