return {
  {
    "folke/which-key.nvim",
    -- opts = function()
    --   local which_key = require("which-key")
    --   which_key.register({
    --     -- ["<leader>m"] = { ":!pwd<CR>", "test" },
    --     -- ["<leader>w"] = { ":update<CR>", "Save" },
    --     -- ["<leader>W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" },
    --     ["<leader>b"] = {
    --       h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
    --       l = {
    --         "<cmd>BufferLineCloseRight<cr>",
    --         "Close all to the right",
    --       },
    --     },
    --   })
    -- end,
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- disable some defaults
      opts.defaults["<leader>w"] = nil

      wk.register(opts.defaults)
    end,
  },
  {
    "Wansmer/treesj",
    -- lazy = true,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 1200,
    },
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd("highlight default link gitblame SpecialComment")
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_message_when_not_committed = ""
      vim.g.gitblame_message_template = "  <author>, <date> • <sha> • <summary>"
      vim.g.gitblame_date_format = "%r"
    end,
  },
  {
    "mg979/vim-visual-multi",
    event = "BufReadPre",
  },
  -- TODO: attach to tailwind
  -- {
  --   "princejoogie/tailwind-highlight.nvim",
  --   lazy = true,
  -- },
  -- {
  --   'akinsho/git-conflict.nvim',
  --   event = "BufReadPre",
  --   opts = {
  --     default_mappings = false
  --   }
  -- }
}
