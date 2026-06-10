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

local function live_grep_word(opts)
  opts = opts or {}

  local query = opts.visual and get_visual_selection() or vim.fn.expand("<cword>")
  opts.visual = nil

  require("fff").live_grep(vim.tbl_deep_extend("force", {
    query = query,
    title = "Grep Word",
  }, opts or {}))
end

local function toggle_fff_preview()
  local ok, picker = pcall(require, "fff.picker_ui.picker_ui")
  if not ok or not picker.state or not picker.state.active then
    return
  end

  local config = picker.state.config
  config.preview = config.preview or {}
  config.preview.enabled = not config.preview.enabled

  picker.relayout()

  if config.preview.enabled then
    picker.update_preview()
  else
    picker.clear_preview()
  end
end

return {
  {
    "dmtrKovalenko/fff.nvim",
    enabled = vim.g.picker_plugin == "fff",
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    lazy = false,
    opts = {
      prompt = "> ",
      layout = {
        height = 0.70,
        width = function(cols)
          return math.min(110 / cols, 0.95)
        end,
        preview_position = "top",
        preview_size = 0.6,
        prompt_position = "top",
        anchor = "center",
        flex = nil,
        path_shorten_strategy = "middle_number",
      },
      preview = {
        enabled = true,
      },
      grep = {
        modes = { "fuzzy", "plain", "regex" },
      },
      hl = {
        matched = "FFFSearchMatch",
        grep_match = "FFFSearchMatch",
      },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, "FFFSearchMatch", {
        link = "Search",
      })

      require("fff").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "fff_input", "fff_list", "fff_preview", "fff_file_info" },
        callback = function(args)
          vim.keymap.set({ "n", "i" }, "<a-p>", toggle_fff_preview, {
            buffer = args.buf,
            silent = true,
            desc = "Toggle FFF preview",
          })
        end,
      })
    end,
    keys = {
      {
        "<leader>ff",
        function()
          require("fff").find_files({ preview = { enabled = false }, title = "Find Files" })
        end,
        desc = "Open file picker",
      },
      {
        "<leader><space>",
        function()
          require("fff").find_files({ preview = { enabled = false }, title = "Find Files" })
        end,
        desc = "Find Files",
      },
      {
        "<leader>sg",
        function()
          require("fff").live_grep({ title = "Grep" })
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>/",
        function()
          require("fff").live_grep({ title = "Grep" })
        end,
        desc = "Grep (cwd)",
      },
      {
        "<leader>sw",
        function()
          live_grep_word()
        end,
        desc = "Visual selection or word",
      },
      {
        "<leader>sw",
        function()
          live_grep_word({ visual = true })
        end,
        desc = "Visual selection or word",
        mode = "x",
      },
      {
        "<leader>sW",
        function()
          live_grep_word({ cwd = vim.fn.getcwd() })
        end,
        desc = "Visual selection or word (cwd)",
      },
      {
        "<leader>sW",
        function()
          live_grep_word({ cwd = vim.fn.getcwd(), visual = true })
        end,
        desc = "Visual selection or word (cwd)",
        mode = "x",
      },
    },
  },
}
