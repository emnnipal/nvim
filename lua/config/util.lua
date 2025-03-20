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

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
function M.get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
    vim.notify(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path),
      "warn"
    )
  end
  return ret
end

return M
