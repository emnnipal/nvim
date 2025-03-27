local M = {}

--- Convert color from number to hex string.
--- @param color number|string The color value, either a number or a hex string.
--- @return string The color in hex format.
function M.to_hex(color)
  if type(color) == "number" then
    return string.format("#%06x", color)
  end
  return color -- Already in hex if not a number
end

--- Darken a hex color by a percentage.
--- @param color string The hex color string (e.g., "#RRGGBB").
--- @param percent number The percentage to darken (0.0 to 1.0).
--- @return string The darkened hex color.
function M.darken(color, percent)
  local r = tonumber(color:sub(2, 3), 16)
  local g = tonumber(color:sub(4, 5), 16)
  local b = tonumber(color:sub(6, 7), 16)

  r = math.floor(r * (1 - percent))
  g = math.floor(g * (1 - percent))
  b = math.floor(b * (1 - percent))

  return string.format("#%02x%02x%02x", r, g, b)
end

return M
