return {
  { -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    lazy = false,
    build = ":TSUpdate",
    branch = "main",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      ---@param buf integer
      ---@param language string
      local function treesitter_try_attach(buf, language)
        -- check if parser exists and load it
        if not vim.treesitter.language.add(language) then
          return
        end
        -- enables syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- enables treesitter based folds
        -- for more info on folds see `:help folds`
        -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

        -- enables treesitter based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end

      local available_parsers = require("nvim-treesitter").get_available()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf, filetype = args.buf, args.match
          local language = vim.treesitter.language.get_lang(filetype)
          if not language then
            return
          end

          local installed_parsers = require("nvim-treesitter").get_installed("parsers")

          if vim.tbl_contains(installed_parsers, language) then
            -- enable the parser if it is installed
            treesitter_try_attach(buf, language)
          elseif vim.tbl_contains(available_parsers, language) then
            -- if a parser is available in `nvim-treesitter` enable it after ensuring it is installed
            require("nvim-treesitter").install(language):await(function()
              treesitter_try_attach(buf, language)
            end)
          else
            -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
            treesitter_try_attach(buf, language)
          end
        end,
      })

      -- ensure basic parser are installed
      require("nvim-treesitter").install(opts.ensure_installed)
    end,
  },

  {
    "daliusd/incr.nvim",
    opts = {
      incr_key = "<C-Space>", -- increment selection key
      decr_key = "<BS>", -- decrement selection key
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<BS>", desc = "Decrement Selection", mode = "x" },
        { "<c-space>", desc = "Increment Selection", mode = { "x", "n" } },
      },
    },
  },
}
