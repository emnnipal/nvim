local M = {}

local function get_visual_selection()
  local ok, lines = pcall(vim.fn.getregion, vim.fn.getpos("'<"), vim.fn.getpos("'>"), {
    type = vim.fn.visualmode(),
  })
  if not ok or not lines or vim.tbl_isempty(lines) then
    return nil
  end

  local text = table.concat(lines, " ")
  text = vim.trim(text)

  return text ~= "" and text or nil
end

local function in_visual_mode()
  local mode = vim.fn.mode()
  return mode == "v" or mode == "V" or mode == "\022"
end

function M.live_grep_word(opts)
  opts = vim.deepcopy(opts or {})

  local query = in_visual_mode() and get_visual_selection() or vim.fn.expand("<cword>")
  opts.query = query
  opts.title = opts.title or "Grep Word"

  require("fff").live_grep(opts)
end

function M.toggle_preview()
  local ok, picker = pcall(require, "fff.picker_ui.picker_ui")
  if not ok or not picker.state or not picker.state.active then
    return
  end

  local config = picker.state.config
  config.preview = config.preview or {}
  config.preview.enabled = not config.preview.enabled

  picker.relayout()

  -- fff paginates grep/file results using the current list window height.
  -- Toggling preview changes that height, so a plain relayout can leave grep
  -- showing only the old, smaller page until the next query/cursor event.
  vim.schedule(function()
    if not picker.state or not picker.state.active then
      return
    end

    local refreshed = pcall(picker.update_results_sync)
    if not refreshed then
      pcall(picker.render_list)
    end

    if config.preview.enabled then
      pcall(picker.update_preview)
    else
      pcall(picker.clear_preview)
    end
  end)
end

function M.move_results(count)
  local ok, picker = pcall(require, "fff.picker_ui.picker_ui")
  if not ok or not picker.state or not picker.state.active then
    return
  end

  local move = count > 0 and picker.move_down or picker.move_up
  for _ = 1, math.abs(count) do
    pcall(move)
  end
end

function M.move_to_edge(edge)
  local ok, picker = pcall(require, "fff.picker_ui.picker_ui")
  if not ok or not picker.state or not picker.state.active then
    return
  end

  local old_cursor = picker.state.cursor

  if edge == "first" then
    pcall(picker.wrap_to_first)
  else
    pcall(picker.wrap_to_last)
  end

  if not pcall(picker.render_after_cursor_move, old_cursor) then
    pcall(picker.render_list)
  end
  pcall(picker.update_preview)
  pcall(picker.update_status)
end

local function copy_selected_path(relative)
  local ok, picker = pcall(require, "fff.picker_ui.picker_ui")
  if not ok or not picker or type(picker.state) ~= "table" then
    return
  end

  local state = picker.state
  local items = state.filtered_items
  local item = type(items) == "table" and items[state.cursor]
  if type(item) ~= "table" or type(item.relative_path) ~= "string" then
    return
  end

  local utils_ok, fff_utils = pcall(require, "fff.utils")
  if not utils_ok or type(fff_utils) ~= "table" or type(fff_utils.canonicalize_fff_path) ~= "function" then
    return
  end

  local path_ok, abs_path = pcall(fff_utils.canonicalize_fff_path, item.relative_path)
  if not path_ok or type(abs_path) ~= "string" or abs_path == "" then
    return
  end

  local path = abs_path
  if relative then
    local relative_ok
    relative_ok, path = pcall(vim.fn.fnamemodify, abs_path, ":.")
    if not relative_ok or type(path) ~= "string" or path == "" then
      return
    end
  end

  vim.fn.setreg("+", path, "c")
end

function M.setup_highlights()
  local orange = vim.api.nvim_get_hl(0, { name = "Constant", link = false })

  -- Grep result list matches use this group. Keep the original Search-style
  -- blue background there.
  vim.api.nvim_set_hl(0, "FFFSearchMatch", { link = "Search" })

  -- fff hardcodes IncSearch for some preview matches. The preview window remaps
  -- IncSearch to this group via winhighlight, so global IncSearch remains owned
  -- by the colorscheme and other plugins such as multicursor.nvim.
  vim.api.nvim_set_hl(0, "FFFPreviewMatch", {
    fg = orange.fg or "#ff9e64",
    bold = true,
  })
end

function M.setup_autocmds()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("FffCustomHighlights", { clear = true }),
    callback = function()
      vim.schedule(M.setup_highlights)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "fff_input", "fff_list", "fff_preview", "fff_file_info" },
    callback = function(args)
      vim.keymap.set({ "n", "i" }, "<a-p>", M.toggle_preview, {
        buffer = args.buf,
        silent = true,
        desc = "Toggle FFF preview",
      })

      vim.keymap.set("n", "J", function()
        M.move_results(10)
      end, {
        buffer = args.buf,
        silent = true,
        desc = "Move down 10 FFF results",
      })

      vim.keymap.set("n", "K", function()
        M.move_results(-10)
      end, {
        buffer = args.buf,
        silent = true,
        desc = "Move up 10 FFF results",
      })

      vim.keymap.set("n", "g", function()
        M.move_to_edge("first")
      end, {
        buffer = args.buf,
        silent = true,
        desc = "Move to first FFF result",
      })

      vim.keymap.set("n", "G", function()
        M.move_to_edge("last")
      end, {
        buffer = args.buf,
        silent = true,
        desc = "Move to last FFF result",
      })

      if args.match == "fff_input" or args.match == "fff_list" then
        vim.keymap.set("n", "Y", function()
          copy_selected_path(false)
        end, {
          buffer = args.buf,
          silent = true,
          desc = "Copy absolute FFF path to clipboard",
        })

        vim.keymap.set("n", "<C-o>", function()
          copy_selected_path(true)
        end, {
          buffer = args.buf,
          silent = true,
          desc = "Copy relative FFF path to clipboard",
        })
      end
    end,
  })
end

return M
