---@type snacks.layout.Box
local vertical_layout = {
  backdrop = false,
  width = 110,
  height = 0.70,
  box = "vertical",
  border = "rounded",
  title = "{source} {live}",
  title_pos = "center",
  -- row = 1,
  { win = "preview", height = 0.6, border = "bottom" },
  { win = "input", height = 1, border = "bottom" },
  { win = "list" },
}

return {
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      -- TODO: remove
      -- "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
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
      -- TODO: for testing, do I really need this?
      -- add any global capabilities here
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
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          --- Maps a keybinding with specified options.
          --- @param key string: The key sequence to bind.
          --- @param func string|function: The function to execute.
          --- @param options? vim.keymap.set.Opts | { mode?: string|string[] } : Optional parameters.
          local function map(key, func, options)
            options = options or {}
            local mode = options.mode or "n"

            options.mode = nil -- Remove mode since it's not a valid option in keymap.set()

            ---@diagnostic disable-next-line: inject-field
            options.buffer = event.buf

            vim.keymap.set(mode, key, func, options)
          end


          -- stylua: ignore start
          -- { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
          -- { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
          -- { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
          map("gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
          map("gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
          map("gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
          map("gh", function() return vim.lsp.buf.hover() end,{ desc = "Hover" })
          map("gk", function() return vim.lsp.buf.signature_help() end,{ desc = "Signature Help" })
          map("<c-k>", function() return vim.lsp.buf.signature_help() end,{ desc = "Signature Help", mode = "i" })
          map("<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", mode = { "n", "v" } })
          map("<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens", mode = { "n", "v" } })
          map("<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
          map("<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Rename File" })
          map("<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })

          -- TODO: how to implement this without lazyvim

          -- map( "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action"),
          -- { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
          --   desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
          -- { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
          --   desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
          -- { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
          --   desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
          -- { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
          --   desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },

          -- TODO: check how lazyvim implemented this to be extensible. 

          -- Snacks picker specific keymaps
          map("<leader>cl", function() Snacks.picker.lsp_config() end, { desc = "Lsp Info" })
          map("gd", function() Snacks.picker.lsp_definitions({ layout = { preview = true, layout = vertical_layout } }) end, { desc = "Goto Definition" })
          map("gr", function() Snacks.picker.lsp_references({ layout = { preview = true, layout = vertical_layout } }) end, { desc = "References", nowait = true })
          map("<leader>ss", function() Snacks.picker.lsp_symbols({ layout = { preview = true, layout = vertical_layout } }) end, { desc = "LSP Symbols" })
          map("<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ layout = { preview = true, layout = vertical_layout } }) end, { desc = "LSP Workspace Symbols" })
          -- stylua: ignore end

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
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
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          -- stylua: ignore
            map("<leader>ch", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })) end, { desc = "Toggle Inlay Hints" })
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

      -- We have noice.nvim for this.
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      --   border = "rounded",
      -- })
      --
      -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      --   border = "rounded",
      -- })

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
