local M = {}

--- Convert color from number to hex
---@param color number|string Color value (either hex or number)
---@return string|nil Hex representation of the color or nil if invalid
function M.to_hex(color)
  if type(color) == "number" then
    return string.format("#%06x", color)
  end
  if type(color) == "string" and color:match("^#%x%x%x%x%x%x$") then
    return color
  end
  return nil -- Return nil for invalid colors
end

--- Darken a color by a given percentage
---@param color string|nil Hex value of the color
---@param percent number Percentage to darken the color
---@return string|nil Darkened hex value or nil if invalid color
function M.darken(color, percent)
  if not color or #color ~= 7 then
    return nil
  end

  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)

  r = math.floor(r * (1 - percent))
  g = math.floor(g * (1 - percent))
  b = math.floor(b * (1 - percent))

  return string.format("#%02x%02x%02x", r, g, b)
end

return M
