-- Source: LazyVim/lua/lazyvim/util/root.lua
local M = {}

function M.is_windows()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

------@type table<number, string>
---M.cache = {}
---
----- returns the root directory based on:
----- * lsp workspace folders
----- * lsp root_dir
----- * root pattern of filename of the current buffer
----- * root pattern of cwd
------@param opts? {normalize?:boolean, buf?:number}
------@return string
---function M.root(opts)
---  opts = opts or {}
---  local buf = opts.buf or vim.api.nvim_get_current_buf()
---  local ret = M.cache[buf]
---  if not ret then
---    local roots = M.detect({ all = false, buf = buf })
---    ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
---    M.cache[buf] = ret
---  end
---  if opts and opts.normalize then
---    return ret
---  end
---  return M.is_windows() and ret:gsub("/", "\\") or ret
---end

-- Source: LazyVim/lua/lazyvim/util/init.lua
local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

function M.git()
  local root = M.get()
  local git_root = vim.fs.find(".git", { path = root, upward = true })[1]
  local ret = git_root and vim.fn.fnamemodify(git_root, ":h") or root
  return ret
end

---@param name string
function M.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

---@param plugin string
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

return M
