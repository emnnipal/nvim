-- Check if running inside tmux
local is_in_tmux = vim.fn.getenv("TMUX") ~= vim.NIL and vim.fn.getenv("TMUX") ~= ""

return {
  {
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

      -- stylua: ignore
      spec = {
        mode = { "n", "v" },
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code", mode = { "n", "x" } },
        { "<leader>f", group = "File/Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gc", group = "Resolve Git Conflicts" },
        -- { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { "<leader>q", group = "Quit/Session" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "UI" },
        { "<leader>x", group = "Diagnostics/Quickfix", icon = { icon = "󱖫 ", color = "green" } },

        {  "<leader>l", "<cmd>Lazy<cr>",  desc = "Lazy"  },

        { "<leader>w", "<Cmd>update<CR>", desc = "Write" },
        { "<leader>W", "<Cmd>noautocmd w<CR>", desc = "Save without formatting" },

        { "<leader>cL", "<Cmd>LspRestart<CR>", desc = "Restart LSP" },

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
        { "<leader>gf", function() Snacks.picker.git_log_file() end,  desc = "Git Current File History" },
        { "<leader>gl", function() Snacks.picker.git_log({ cwd = vim.fn.getcwd() }) end,  desc = "Git Log" },
        { "<leader>gL", function() Snacks.picker.git_log() end,  desc = "Git Log (cwd)" },
        { "<leader>gb", function() Snacks.picker.git_log_line() end,  desc = "Git Blame Line"  },
        { "<leader>gB", function() Snacks.gitbrowse() end,  desc = "Git Browse (open)" },
      },
    },
  },
}
