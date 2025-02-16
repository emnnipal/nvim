return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      icons = {
        mappings = false, -- disable all icons in which-key
      },
      spec = {
        { "<leader>w", "<Cmd>update<CR>", desc = "Write" },
        { "<leader>W", "<Cmd>noautocmd w<CR>", desc = "Save without formatting" },
        { "<leader>bh", "<Cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
        { "<leader>bl", "<Cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },

        { "<leader>m", "<Cmd>TSJToggle<CR>", desc = "Toggle split/join" },
        { "<leader>j", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
        { "<leader>k", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },

        { "<leader>cL", "<Cmd>LspRestart<CR>", desc = "Restart LSP" },

        {
          "<leader>gg",
          function()
            ---@module 'snacks'
            ---@diagnostic disable-next-line: missing-fields
            Snacks.lazygit({
              cwd = LazyVim.root.git(),
              win = {
                width = 0,
                height = 0,
                style = "lazygit",
                keys = {
                  term_normal = false, -- Prevent from going to normal mode with esc_esc when in lazygit
                },
              },
            })
          end,
          desc = "Lazygit (cwd)",
        },

        { "<leader>i", group = "Utilities" },
        { "<leader>ie", "<Cmd>EslintFixAll<CR>", desc = "Fix eslint errors" },
        { "<leader>it", "<Cmd>vs#<CR>", desc = "Reopen recently closed buffer" },

        { "<leader>ic", group = "Resolve Git Conflicts" },
        { "<leader>ica", "<Cmd>GitConflictListQf<CR>", desc = "Get all conflict to quickfix" },
        { "<leader>icb", "<Cmd>GitConflictChooseBoth<CR>", desc = "Choose both" },
        { "<leader>icj", "<Cmd>GitConflictPrevConflict<CR>", desc = "Move to previous conflict" },
        { "<leader>ick", "<Cmd>GitConflictNextConflict<CR>", desc = "Move to next conflict" },
        { "<leader>icn", "<Cmd>GitConflictChooseNone<CR>", desc = "Choose none" },
        { "<leader>ico", "<Cmd>GitConflictChooseOurs<CR>", desc = "Choose ours" },
        { "<leader>ict", "<Cmd>GitConflictChooseTheirs<CR>", desc = "Choose theirs" },

        {
          "<leader>qc",
          function()
            Snacks.bufdelete()
          end,
          desc = "Close Buffer",
        },
        {
          "<leader>gl",
          function()
            Snacks.lazygit.log({ cwd = LazyVim.root.git() })
          end,
          desc = "Lazygit Log",
        },
        {
          "<leader>gL",
          function()
            Snacks.lazygit.log()
          end,
          desc = "Lazygit Log (cwd)",
        },
      },
    },
  },
}
