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
    result = result .. string.format("%%#StatuslineError#%d ●%%* ", errors)
  end

  if warnings > 0 then
    result = result .. string.format("%%#StatuslineWarn#%d ▲%%* ", warnings)
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
  }

  vim.api.nvim_set_hl(0, "StatuslineError", { fg = "#ff5555", bold = true })
  vim.api.nvim_set_hl(0, "StatuslineWarn", { fg = "#ffb86c", bold = true })
  vim.o.statusline = table.concat(statusline, "")
end

return M
