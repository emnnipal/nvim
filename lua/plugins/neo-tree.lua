return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  -- opts = {
  --   filesystem = {
  --     window = {
  --       mappings = {
  --         ['\\'] = 'close_window',
  --       },
  --     },
  --   },
  -- },
  -- NOTE: from lazyvim
  -- deactivate = function()
  --   vim.cmd [[Neotree close]]
  -- end,

  opts = {
    -- NOTE: from lazyvim
    -- sources = { 'filesystem', 'buffers', 'git_status' },
    -- open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_by_name = {
          ".git",
          "node_modules",
        },
        always_show = {
          ".env",
        },
      },
      -- NOTE: from lazyvim
      -- bind_to_cwd = false,
      -- follow_current_file = { enabled = true },
      -- use_libuv_file_watcher = true,
    },
    window = {
      popup = {
        size = {
          width = 120,
        },
      },
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["Y"] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
          end,
          desc = "Copy Path to Clipboard",
        },
        ["O"] = {
          function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          desc = "Open with System Application",
        },
        ["P"] = { "toggle_preview", config = { use_float = false } },
      },
    },
    default_component_configs = {
      type = {
        enabled = false,
      },
      -- icon = {
      --   enabled = false,
      -- },
      indent = {
        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      git_status = {
        symbols = {
          unstaged = "󰄱",
          staged = "󰱒",
        },
      },
    },
  },
  config = function(_, opts)
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end

    local events = require("neo-tree.events")
    opts.event_handlers = opts.event_handlers or {}
    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    })
    require("neo-tree").setup(opts)
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,

  keys = {
    -- { -- TODO: this seems to be the same as <leader>E which is opening neo-tree relative the cwd regardless if we are in a monorepo.
    --   "<leader>e",
    --   function()
    --     require("neo-tree.command").execute({
    --       toggle = true,
    --       dir = vim.fn.getcwd(), -- TODO: this seems to be not the correct Lazyvim.root equivalent
    --       reveal = true,
    --       position = "float",
    --     })
    --   end,
    --   desc = "Explorer NeoTree (Root Dir)",
    -- },
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({
          toggle = true,
          dir = vim.uv.cwd(),
          reveal = true,
          position = "float",
        })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true, position = "float" })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true, position = "float" })
      end,
      desc = "Buffer Explorer",
    },
  },
}
