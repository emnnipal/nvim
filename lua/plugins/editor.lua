return {
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically

  {
    "smoka7/hop.nvim",
    event = "BufReadPre",
    config = function()
      local hop = require("hop")
      hop.setup()
      vim.keymap.set("n", "m", function()
        hop.hint_words()
      end, { remap = true, desc = "Hop" })
    end,
  },

  {
    "Wansmer/treesj",
    event = "BufWritePre",
    dependencies = { "nvim-treesitter" },
    opts = {
      use_default_keymaps = false,
      max_join_length = 1200,
    },
    keys = {
      { "<leader>m", "<Cmd>TSJToggle<CR>", desc = "Toggle split/join" },
    },
  },
  {
    "kylechui/nvim-surround",
    event = "BufReadPre",
    opts = {},
  },
  {
    "mg979/vim-visual-multi",
    event = "BufReadPre",
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    opts = {
      default_mappings = false,
    },
    keys = {
      { "<leader>gca", "<Cmd>GitConflictListQf<CR>", desc = "Get all conflict to quickfix" },
      { "<leader>gcb", "<Cmd>GitConflictChooseBoth<CR>", desc = "Choose both" },
      { "<leader>gcj", "<Cmd>GitConflictPrevConflict<CR>", desc = "Move to previous conflict" },
      { "<leader>gck", "<Cmd>GitConflictNextConflict<CR>", desc = "Move to next conflict" },
      { "<leader>gcn", "<Cmd>GitConflictChooseNone<CR>", desc = "Choose none" },
      { "<leader>gco", "<Cmd>GitConflictChooseOurs<CR>", desc = "Choose ours" },
      { "<leader>gct", "<Cmd>GitConflictChooseTheirs<CR>", desc = "Choose theirs" },
    },
  },

  -- Automatically add closing tags for HTML and JSX
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
  },

  -- comments
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
