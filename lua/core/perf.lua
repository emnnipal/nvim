-- Utility for measuring my lua code performance
local M = {}

function M.start()
  M.start_time = vim.loop.hrtime()
end

function M.print_elapsed(label)
  if not M.start_time then
    print("[Perf] Timer not started! Call perf.start() first.")
    return
  end

  local elapsed_time = (vim.loop.hrtime() - M.start_time) / 1e6 -- Convert to ms
  print(string.format("[Perf] %s: %.3fms", label, elapsed_time))
end

return M
