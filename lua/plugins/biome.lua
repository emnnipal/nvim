---@diagnostic disable: inject-field
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        require_cwd = true,
        stdin = true,
        -- args = { "check", "--write", "--unsafe", "--stdin-file-path", "$FILENAME" }, -- auto organize imports, fix lint and format on save
        args = { "check", "--write", "--stdin-file-path", "$FILENAME" }, -- auto organize imports, fix lint and format on save
      }
    end,
  },
}
