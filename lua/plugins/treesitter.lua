return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add your desired syntax parsers here to ensure they are installed
      vim.list_extend(opts.ensure_installed, { "svelte" })
    end,
  },
}
