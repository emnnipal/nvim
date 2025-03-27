-- Check if running inside tmux
local is_in_tmux = vim.fn.getenv("TMUX") ~= vim.NIL and vim.fn.getenv("TMUX") ~= ""

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
      -- stylua: ignore
      spec = {
        mode = { "n", "v" },
        -- { '<leader>r', group = '[R]ename' },
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code", mode = { "n", "x" } },
        { "<leader>f", group = "File/Find" },
        { "<leader>g", group = "Git" },
        -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "UI" },
        { "<leader>x", group = "Diagnostics/Quickfix", icon = { icon = "󱖫 ", color = "green" } },

        {  "<leader>l", "<cmd>Lazy<cr>",  desc = "Lazy"  },

        { "<leader>w", "<Cmd>update<CR>", desc = "Write" },
        { "<leader>W", "<Cmd>noautocmd w<CR>", desc = "Save without formatting" },
        -- { "<leader>bh", "<Cmd>BufferLineCloseLeft<cr>", desc = "Close all to the left" },
        -- { "<leader>bl", "<Cmd>BufferLineCloseRight<cr>", desc = "Close all to the right" },

        -- { "<leader>j", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer" },
        -- { "<leader>k", "<Cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },

        { "<leader>cL", "<Cmd>LspRestart<CR>", desc = "Restart LSP" },

        -- {
        --   "<leader>gg",
        --   -- Check if the tmux window "lg" already exists; if it does, switch to it. Otherwise, create a new window for lazygit.
        --   "<cmd>silent !tmux list-windows | grep -q 'lg' && tmux select-window -t lg || tmux new-window -n lg 'lazygit'<CR>",
        --   desc = "Lazygit (cwd)",
        -- },

        -- Git
        {
          "<leader>gg",
          function()
            local cwd = vim.fn.getcwd()

            if is_in_tmux then
              local project_name = vim.fn.fnamemodify(cwd, ":t") -- Get the last part of the path (project name)
              local tmux_window = "lg-" .. project_name -- Create a unique tmux window name

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
              Snacks.lazygit({
                cwd = cwd,
                win = {
                  width = 0,
                  height = 0.99, -- Not 100% so that the statusline of lazygit isn't hidden by the command line of neovim.
                  style = "lazygit",
                  keys = {
                    term_normal = false, -- Prevent from going to normal mode with esc_esc when in lazygit
                  },
                },
              })
            end

          end,
          desc = "Lazygit (cwd)",
        },

        -- { "<leader>gG", function() Snacks.lazygit() end,  desc = "Lazygit (cwd)" },
        -- stylua: ignore
        { "<leader>gf", function() Snacks.picker.git_log_file() end,  desc = "Git Current File History" },
        -- stylua: ignore
        { "<leader>gl", function() Snacks.picker.git_log({ cwd = vim.fn.getcwd() }) end,  desc = "Git Log" },
        -- stylua: ignore
        { "<leader>gL", function() Snacks.picker.git_log() end,  desc = "Git Log (cwd)" },
        { "<leader>gb", function() Snacks.picker.git_log_line() end,  desc = "Git Blame Line"  },
        { "<leader>gB", function() Snacks.gitbrowse() end,  desc = "Git Browse (open)" },


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

      },
    },
  },
}
