return {
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      -- NOTE: ensure only LSP servers are installed here, mason.nvim handles formatters
      servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      },
      setup = {},
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("nvim-lsp-attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if not client then
            return
          end

          local keymaps = require("core.keymaps")

          -- Setup default/global LSP keymaps
          keymaps.setup(event.buf, client)

          -- Setup LSP-specific keymaps for the current client
          local server_opts = opts.servers[client.name]
          if server_opts and server_opts.keys then
            keymaps.setup(event.buf, client, server_opts.keys)
          end

          local server_setup = opts.setup[client.name]
          if server_setup then
            server_setup(client, server_opts or {})
          end

          -- Highlight references of the word under your cursor when your cursor rests there
          -- for a little while.
          --    See `:help CursorHold` for information about when this is executed
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("nvim-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("nvim-lsp-detach", { clear = true }),
              callback = function(detach_event)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "nvim-lsp-highlight", buffer = detach_event.buf })
              end,
            })
          end

          -- Toggle inlay hints
          -- This may be unwanted, since they displace some of your code
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            keymaps.map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, { desc = "Toggle Inlay Hints", buffer = event.buf })
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = {
          -- border = "rounded",
          source = "if_many",
        },
        underline = true,
        -- underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      -- local has_blink, blink = pcall(require, "blink.cmp")

      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        -- has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local servers = opts.servers or {}
      local ensure_installed = vim.tbl_keys(servers or {})

      -- NOTE: if you want a single plugin handling all the plugin installation, regardless if it's an LSP or a formatter or whatnot, use this.
      -- vim.list_extend(ensure_installed, {
      --   "stylua", -- Used to format Lua code
      -- })
      -- require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed, -- NOTE: if you use mason-tool-installer, set this to empty table {}
        automatic_installation = true, -- NOTE: if you use mason-tool-installer, set this to false.
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
