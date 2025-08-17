return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      {
        "mason-org/mason-lspconfig.nvim",
        version = "1.32.0", -- TODO: remove once we have migrated our lspconfig to new vim.lsp.config of nvim 0.11
      },

      { "j-hui/fidget.nvim", opts = {} },

      vim.g.cmp_plugin == "nvim-cmp" and "hrsh7th/cmp-nvim-lsp" or nil,
      vim.g.cmp_plugin == "blink" and "saghen/blink.cmp" or nil,
      vim.g.cmp_plugin == "nvim-ix" and "hrsh7th/nvim-ix" or nil,
    },
    opts = {
      -- inlay_hints = { enabled = true },
      -- autoformat = false, -- disable autoformat for lsp
      -- NOTE: ensure only LSP servers are installed here, mason.nvim handles formatters
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
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

          local keymaps = require("core.lsp-keymaps")

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
          if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            keymaps.map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, { desc = "Toggle Inlay Hints", buffer = event.buf })
          end
        end,
      })

      local icon = require("util.icons")

      -- Diagnostic Config
      vim.diagnostic.config({
        severity_sort = true,
        float = {
          -- border = "rounded",
          source = "if_many",
        },
        underline = true,
        -- underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icon.diagnostic.ERROR,
            [vim.diagnostic.severity.WARN] = icon.diagnostic.WARN,
            [vim.diagnostic.severity.INFO] = icon.diagnostic.INFO,
            [vim.diagnostic.severity.HINT] = icon.diagnostic.HINT,
          },
        },
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
      local has_blink, blink = pcall(require, "blink.cmp")

      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
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
        automatic_installation = true, -- TODO: remove once mason is updated to latest (2.x.x)
        automatic_enable = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
