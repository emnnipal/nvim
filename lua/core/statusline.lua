local M = {}

_G._statusline = M

function M.diagnostic_status()
  local ignore_modes = {
    ["c"] = true, -- command mode
    ["t"] = true, -- terminal mode
  }

  if ignore_modes[vim.api.nvim_get_mode().mode] then
    return ""
  end

  local levels = vim.diagnostic.severity
  local errors = #vim.diagnostic.get(0, { severity = levels.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = levels.WARN })

  local result = ""

  if errors > 0 then
    result = result .. string.format("%%#StatusLineError#%d ●%%* ", errors)
  end

  if warnings > 0 then
    result = result .. string.format("%%#StatusLineWarn#%d ▲%%* ", warnings)
  end

  return result
end

function M.active_lsp()
  local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
  if #buf_clients == 0 then
    return "LSP Inactive"
  end

  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end

  local unique_client_names = table.concat(buf_client_names, ", ")
  local language_servers = string.format("[%s]", unique_client_names)

  return language_servers
end

local modes = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  c = "COMMAND",
  R = "REPLACE",
  s = "SELECT",
  t = "TERMINAL",
}

function M.display_mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return modes[current_mode] or current_mode
end

function M.get_scrollbar()
  local sbar_chars = {
    "▔",
    "🮂",
    "🬂",
    "🮃",
    "▀",
    "▄",
    "▃",
    "🬭",
    "▂",
    "▁",
  }

  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)

  local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
  local sbar = string.rep(sbar_chars[i], 2)

  return "%#StatusLineScroll#" .. sbar .. "%*"
end

function M.setup()
  local statusline = {
    " %{%v:lua._statusline.display_mode()%}  ",
    '%{expand("%:~:.")}', -- show current buffer file path relative to cwd
    " %r",
    "%m",
    -- " - %{&filetype} ",
    "%=",
    "%{%v:lua._statusline.diagnostic_status()%}",
    "%{%v:lua._statusline.active_lsp()%}",
    -- " %2p%% ", -- show line position in percentage
    -- " %3l:%-2c ", -- show cursor position in column and row number
    "  ",
    "%{%v:lua._statusline.get_scrollbar()%}",
    " ",
  }

  -- Set status line highlights
  local cursor_hl = vim.api.nvim_get_hl(0, { name = "CursorLineNr", link = false })
  local error_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticError", link = false })
  local warning_hl = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn", link = false })

  vim.api.nvim_set_hl(0, "StatusLineScroll", { fg = cursor_hl.fg, bg = cursor_hl.bg })
  vim.api.nvim_set_hl(0, "StatusLineError", { fg = error_hl.fg, bold = true })
  vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = warning_hl.fg, bold = true })

  vim.o.statusline = table.concat(statusline, "")
end

return M
