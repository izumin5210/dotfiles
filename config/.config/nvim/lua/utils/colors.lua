local M = {}

local palletes = require("catppuccin.palettes")
local palette = palletes.get_palette("frappe")

M.palette = palette

---@alias RGB { r: number, g: number, b: number }

---Converts a hex color code to RGB
---@param hex string Color code in '#RRGGBB' format
---@return RGB
function M.hex_to_rgb(hex)
  hex = hex:gsub("^#", "")
  if #hex ~= 6 then
    error("Invalid hex color code. Must be in the format #RRGGBB")
  end
  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)
  return { r = r, g = g, b = b }
end

---Converts RGB to a hex color code
---@param color RGB
---@return string Color code in '#RRGGBB' format
function M.rgb_to_hex(color)
  local function component_to_hex(c)
    return string.format("%02x", math.floor(c + 0.5))
  end
  local r = component_to_hex(color.r)
  local g = component_to_hex(color.g)
  local b = component_to_hex(color.b)
  return "#" .. r .. g .. b
end

---Performs alpha blending
---@param foreground string Foreground color in '#RRGGBB' format
---@param background string Background color in '#RRGGBB' format
---@param alpha number Alpha value between 0 and 1
---@return string Blended color in '#RRGGBB' format
function M.alpha_blend(foreground, background, alpha)
  -- Check if inputs are in the correct format
  if type(foreground) ~= "string" or type(background) ~= "string" then
    error("foreground and background must be strings in the format #RRGGBB")
  end

  local fg = M.hex_to_rgb(foreground)
  local bg = M.hex_to_rgb(background)

  -- Clamp alpha value between 0 and 1
  alpha = math.max(0, math.min(1, alpha))

  local r = fg.r * alpha + bg.r * (1 - alpha)
  local g = fg.g * alpha + bg.g * (1 - alpha)
  local b = fg.b * alpha + bg.b * (1 - alpha)

  return M.rgb_to_hex({ r = r, g = g, b = b })
end

return M
