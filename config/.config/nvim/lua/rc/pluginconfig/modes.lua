local M = {}

function M.setup()
  local colors = require("rc.colors")
  local palette = colors.palette

  require("modes").setup({
    colors = {
      copy = colors.alpha_blend(palette.yellow, palette.base, 0.2),
      delete = colors.alpha_blend(palette.red, palette.base, 0.2),
      insert = colors.alpha_blend(palette.sky, palette.base, 0.2),
      visual = colors.alpha_blend(palette.mauve, palette.base, 0.2),
    },
    line_opacity = 1,
  })
end

return M
