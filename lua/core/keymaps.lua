local M = {}

--- Maps a keybinding with specified options.
--- @param key string: The key sequence to bind.
--- @param func string|function: The function to execute.
--- @param options? vim.keymap.set.Opts | { mode?: string|string[], has?: string|string[], cond?: function } : Optional parameters.
function M.map(key, func, options)
  options = options or {}
  local mode = options.mode or "n"

  options.mode = nil -- Remove mode since it's not a valid option in keymap.set()

  local has_capability = true
  local should_map = true

  -- -- Check for LSP capabilities if `has` is defined
  -- if options.has then
  --   has_capability = M.check_capabilities(options.has)
  -- end

  -- Check the condition function if `cond` is defined
  if options.cond then
    should_map = options.cond()
    options.cond = nil
  end

  ---@diagnostic disable-next-line: inject-field
  options.has = nil -- TODO: set keymap based on has param

  -- Only map the key if both conditions are satisfied
  if has_capability and should_map then
    vim.keymap.set(mode, key, func, options)
  end
end

--- TODO:
--- --- Checks if the attached LSP client(s) have the specified capability.
--- --- @param capabilities string|string[]: The capability or list of capabilities to check.
--- --- @return boolean
--- function M.check_capabilities(capabilities)
---   local clients = vim.lsp.get_active_clients({ bufnr = 0 })
---   if not clients or vim.tbl_isempty(clients) then
---     return false
---   end
---
---   -- Normalize capabilities to a table if it's a string
---   if type(capabilities) == "string" then
---     capabilities = { capabilities }
---   end
---
---   for _, client in ipairs(clients) do
---     for _, capability in ipairs(capabilities) do
---       if client.server_capabilities[capability .. "Provider"] then
---         return true
---       end
---     end
---   end
---
---   return false
--- end

--- @class KeymapConfig: vim.keymap.set.Opts
--- @field [1] string # The key sequence(s) to bind.
--- @field [2] string|function # The function or command to execute.
--- @field mode? string|string[] # Keymap mode(s) (default is "n").
--- @field has? string|string[] # Optional condition(s) to check for capability.
--- @field cond? function # Optional condition to evaluate before applying the keymap.

--- @param keys KeymapConfig[]
function M.extend_keymaps(keys)
  vim.list_extend(M.get(), keys)
end

function M.get()
  if M._keys then
    return M._keys
  end

  --- @type KeymapConfig[]
  -- stylua: ignore
  M._keys =  {
    { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info",  },
    { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
    { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
    { "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
    { "gh", function() return vim.lsp.buf.hover() end, desc = "Display hover" },
    { "gk", function() return vim.lsp.buf.signature_help() end, desc = "Signature Help", has = "signatureHelp" },
    { "<A-k>", function() return vim.lsp.buf.signature_help() end, mode = "i", desc = "Signature Help", has = "signatureHelp" },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" },
    { "<leader>cc", vim.lsp.codelens.run, desc = "Run Codelens", mode = { "n", "v" }, has = "codeLens" },
    { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" }, has = "codeLens" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode ={"n"}, has = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
    -- { "<leader>cA", LazyVim.lsp.action.source, desc = "Source Action", has = "codeAction" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, has = "documentHighlight",
      desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, has = "documentHighlight",
      desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
    { "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, has = "documentHighlight",
      desc = "Next Reference", cond = function() return Snacks.words.is_enabled() end },
    { "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, has = "documentHighlight",
      desc = "Prev Reference", cond = function() return Snacks.words.is_enabled() end },
  }

  return M._keys
end

--- @param keys KeymapConfig[] : Optional parameters.
--- @param buffer? boolean|integer : Optional parameters.
function M.register_keymaps(keys, buffer)
  for _, keymap in ipairs(keys) do
    local key = keymap[1] -- The key sequence
    local func = keymap[2] -- The function to execute

    -- Extract options from keymap
    local options = {}
    for index, value in pairs(keymap) do
      if type(index) == "string" then
        options[index] = value
      end
    end

    -- TODO: map based on has and cond options

    if buffer then
      options.buffer = buffer
    end
    M.map(key, func, options)
  end
end

-- Setup LSP-specific keymaps for the current client
--- @param buffer boolean|integer : buffer number from autocmd event
--- @param client_name string : lsp client name used for caching
--- @param keys? KeymapConfig[] : keymaps
function M.setup(buffer, client_name, keys)
  local lsp_keymap_name = "lsp_keymaps_" .. client_name
  local lsp_keymaps_set = vim.b[buffer][lsp_keymap_name]

  -- Track if specific keymaps have been set for this LSP
  if lsp_keymaps_set then
    return
  end

  vim.b[buffer][lsp_keymap_name] = true

  local derived_keymaps = keys or M.get()
  M.register_keymaps(derived_keymaps, buffer)
end

return M
