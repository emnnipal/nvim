return {
  "hrsh7th/nvim-ix",
  enabled = vim.g.cmp_plugin == "nvim-ix",
  dependencies = {
    "hrsh7th/nvim-cmp-kit",
  },
  config = function()
    local ix = require("ix")
    ix.setup({
      expand_snippet = function(snippet_body)
        vim.snippet.expand(snippet_body) -- for `neovim built-in` users
      end,
      completion = {
        preselect = true,
        auto_select_first = true,
        lsp = {
          servers = {
            -- This is example configuration for emmet_language_server.
            emmet_language_server = {
              priority = -1,
            },
          },
        },
      },
      signature_help = {
        auto = false,
      },
      attach = {
        insert_mode = function()
          -- do not allow 'prompt' buftype so that cmp won't show in snacks picker
          if vim.bo.buftype == "nofile" or vim.bo.buftype == "prompt" then
            return
          end
          do
            local service = ix.get_completion_service({ recreate = true })
            -- service:register_source(ix.source.completion.github(), { group = 1 })
            -- service:register_source(ix.source.completion.calc(), { group = 1 })
            -- service:register_source(ix.source.completion.emoji(), { group = 1 })
            service:register_source(ix.source.completion.path(), { group = 10 })
            ix.source.completion.attach_lsp(service, { group = 20 })
            -- service:register_source(ix.source.completion.buffer(), { group = 30, dedup = true })
          end
          do
            local service = ix.get_signature_help_service({ recreate = true })
            ix.source.signature_help.attach_lsp(service)
          end
        end,
      },
    })

    vim.keymap.set({ "i", "c" }, "<C-f>", ix.action.scroll(0 + 3))
    vim.keymap.set({ "i", "c" }, "<C-b>", ix.action.scroll(0 - 3))

    vim.keymap.set({ "i", "c" }, "<C-Space>", ix.action.completion.complete())
    vim.keymap.set({ "i", "c" }, "<Tab>", ix.action.completion.select_next())
    vim.keymap.set({ "i", "c" }, "<S-Tab>", ix.action.completion.select_prev())
    vim.keymap.set({ "i", "c" }, "<C-e>", ix.action.completion.close())
    ix.charmap.set("c", "<CR>", ix.action.completion.commit_cmdline())
    ix.charmap.set("i", "<CR>", ix.action.completion.commit())
    vim.keymap.set("i", "<Down>", ix.action.completion.select_next())
    vim.keymap.set("i", "<Up>", ix.action.completion.select_prev())
    vim.keymap.set(
      "i",
      "<C-y>",
      ix.action.completion.commit({ select_first = true, replace = true, no_snippet = true })
    )

    vim.keymap.set({ "i", "s" }, "<C-o>", ix.action.signature_help.trigger_or_close())
    vim.keymap.set({ "i", "s" }, "<C-j>", ix.action.signature_help.select_next())
  end,
}
