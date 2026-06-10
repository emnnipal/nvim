local M = {}

local last_picker

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

function M.open_picker(kind, opts)
  opts = vim.deepcopy(opts or {})
  last_picker = { kind = kind, opts = opts }

  if kind == "files" then
    require("fff").find_files(vim.deepcopy(opts))
  else
    require("fff").live_grep(vim.deepcopy(opts))
  end
end

function M.open_snacks_picker(open)
  last_picker = { kind = "snacks" }
  open()
end

function M.capture_query()
  if not last_picker or last_picker.kind == "snacks" then
    return
  end

  local ok, picker = pcall(require, "fff.picker_ui.picker_ui")
  if not ok or not picker.state then
    return
  end

  if picker.state.query and picker.state.query ~= "" then
    last_picker.opts.query = picker.state.query
  else
    last_picker.opts.query = nil
  end
end

function M.resume_picker()
  if not last_picker then
    vim.notify("No FFF picker to resume", vim.log.levels.WARN)
    return
  end

  if last_picker.kind == "snacks" then
    Snacks.picker.resume()
    return
  end

  M.open_picker(last_picker.kind, last_picker.opts)
end

function M.live_grep_word(opts)
  opts = vim.deepcopy(opts or {})

  local query = opts.visual and get_visual_selection() or vim.fn.expand("<cword>")
  opts.visual = nil
  opts.query = query
  opts.title = opts.title or "Grep Word"

  M.open_picker("grep", opts)
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

function M.setup_highlights()
  vim.api.nvim_set_hl(0, "FFFSearchMatch", {
    link = "Search",
  })
end

function M.setup_autocmds()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "fff_input", "fff_list", "fff_preview", "fff_file_info" },
    callback = function(args)
      vim.keymap.set({ "n", "i" }, "<a-p>", M.toggle_preview, {
        buffer = args.buf,
        silent = true,
        desc = "Toggle FFF preview",
      })

      if vim.bo[args.buf].filetype == "fff_input" then
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
          buffer = args.buf,
          callback = function()
            vim.schedule(M.capture_query)
          end,
        })

        vim.api.nvim_create_autocmd({ "BufLeave", "BufWipeout" }, {
          buffer = args.buf,
          callback = M.capture_query,
        })
      end
    end,
  })
end

return M
