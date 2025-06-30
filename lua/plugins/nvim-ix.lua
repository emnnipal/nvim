return {
  "hrsh7th/nvim-ix",
  enabled = vim.g.cmp_plugin == "nvim-ix",
  dependencies = {
    "hrsh7th/nvim-cmp-kit",
  },
  config = function()
    local ix = require("ix")
    ix.setup({
      completion = {
        preselect = true,
      },
    })

    vim.keymap.set({ "i", "c" }, "<C-f>", ix.action.scroll(0 + 3))
    vim.keymap.set({ "i", "c" }, "<C-b>", ix.action.scroll(0 - 3))

    vim.keymap.set({ "i", "c" }, "<C-Space>", ix.action.completion.complete())
    vim.keymap.set({ "i", "c" }, "<Tab>", ix.action.completion.select_next())
    vim.keymap.set({ "i", "c" }, "<S-Tab>", ix.action.completion.select_prev())
    vim.keymap.set({ "i", "c" }, "<C-e>", ix.action.completion.close())
    ix.charmap.set("c", "<CR>", ix.action.completion.commit_cmdline())
    ix.charmap.set("i", "<CR>", ix.action.completion.commit({ select_first = true }))
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
