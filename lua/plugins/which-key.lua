local has_tmux = vim.fn.executable("tmux") == 1

return {
  { -- Useful plugin to show you pending keybinds.
    "folke/which-key.nvim",
    event = "VimEnter", -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      -- delay = 0,
      preset = "helix",
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = false,
      },

      -- Document existing key chains
      spec = {
        mode = { "n", "v" },
        -- { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        -- { '<leader>d', group = '[D]ocument' },
        -- { '<leader>r', group = '[R]ename' },
        { "<leader>s", group = "[S]earch" },
        -- { '<leader>w', group = '[W]orkspace' },
        -- { '<leader>t', group = '[T]oggle' },
        -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },

        { "<leader>w", "<Cmd>update<CR>", desc = "Write" },
        { "<leader>W", "<Cmd>noautocmd w<CR>", desc = "Save without formatting" },
        { "<leader>bh", "<Cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
        { "<leader>bl", "<Cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },

        { "<leader>m", "<Cmd>TSJToggle<CR>", desc = "Toggle split/join" },
        { "<leader>j", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
        { "<leader>k", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },

        { "<leader>cL", "<Cmd>LspRestart<CR>", desc = "Restart LSP" },

        -- {
        --   "<leader>gg",
        --   -- Check if the tmux window "lg" already exists; if it does, switch to it. Otherwise, create a new window for lazygit.
        --   "<cmd>silent !tmux list-windows | grep -q 'lg' && tmux select-window -t lg || tmux new-window -n lg 'lazygit'<CR>",
        --   desc = "Lazygit (cwd)",
        -- },

        {
          "<leader>gg",
          function()
            local cwd = vim.fn.getcwd()
            local project_name = vim.fn.fnamemodify(cwd, ":t") -- Get the last part of the path (project name)
            local tmux_window = "lg-" .. project_name -- Create a unique tmux window name

            if has_tmux then
              vim.fn.system(
                string.format(
                  "tmux list-windows | grep -q '%s' && tmux select-window -t %s || tmux new-window -n %s 'lazygit'",
                  tmux_window,
                  tmux_window,
                  tmux_window
                )
              )
            else
              ---@module 'snacks'
              ---@diagnostic disable-next-line: missing-fields
              -- Snacks.lazygit({
              --   cwd = cwd,
              --   win = {
              --     width = 0,
              --     height = 0,
              --     style = "lazygit",
              --     keys = {
              --       term_normal = false, -- Prevent from going to normal mode with esc_esc when in lazygit
              --     },
              --   },
              -- })
            end
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

        -- stylua: ignore
        { "<leader>qc", function() Snacks.bufdelete() end, desc = "Close Buffer" },
        -- stylua: ignore
        { "<leader>gl", function() Snacks.lazygit.log({ cwd = LazyVim.root.git() }) end, desc = "Lazygit Log" },
        -- stylua: ignore
        { "<leader>gL", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      },
    },
  },
}
