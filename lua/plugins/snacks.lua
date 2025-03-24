-- TODO: use mini.icons
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      dashboard = {
        enabled = true,
        preset = {
          header = [[
  ,-.       _,---._ __  / \  
 /  )    .-'       `./ /   \ 
(  (   ,'            `/    /|
 \  `-"             \'\   / |
  `.              ,  \ \ /  |
   /`.          ,'-`----Y   |
  (            ;        |   '
  |  ,-.    ,-'         |  / 
  |  | (   |            | /  
  )  |  \  `.___________|/   
  `--'   `--'                
           __..--''``---....___   _..._    __         
 /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
///_.-' _..--.'_    \                    `( ) ) // // 
/ (_..-' // (< _     ;_..__               ; `' / ///  
 / // // //  `-._,_)' // / ``--...____..-' /// / //   
]],
        },
      },
      indent = { enabled = true, scope = { enabled = false } },
      picker = { enabled = true },
      -- indent = {
      --   scope = { enabled = false },
      -- },
      explorer = { enabled = false },
      input = {
        enabled = true,
        icon_pos = false,
        win = {
          title_pos = "left",
          width = 35,
          relative = "cursor",
          row = -3,
          col = 0,
        },
      },

      notifier = { enabled = false },
      scope = { enabled = false },
      scroll = { enabled = true },
      statuscolumn = { enabled = false },
      toggle = { enabled = false },
      words = { enabled = false },

      bigfile = { enabled = false },
      quickfile = { enabled = false },
      -- styles = {
      --   notification = {
      --     -- wo = { wrap = true } -- Wrap notifications
      --   },
      -- },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command
        end,
      })
    end,
  },

  -- Snacks Explorer
  -- {
  --   "snacks.nvim",
  --   ---@module 'snacks'
  --   ---@type snacks.Config
  --   ---@diagnostic disable-next-line: missing-fields
  --   opts = {
  --     explorer = {
  --       enabled = LazyVim.has_extra("editor.snacks_explorer"),
  --       replace_netrw = true,
  --     },
  --     picker = {
  --       sources = {
  --         explorer = {
  --           auto_close = true,
  --           layout = {
  --             preset = "vertical",
  --             layout = {
  --               -- position = "float"
  --               width = 120,
  --             },
  --           },
  --           ---@diagnostic disable: missing-fields
  --           icons = {
  --             -- tree = {
  --             --   vertical = "│  ",
  --             --   middle = "├╴ ",
  --             --   last = "└╴ ",
  --             -- },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}
