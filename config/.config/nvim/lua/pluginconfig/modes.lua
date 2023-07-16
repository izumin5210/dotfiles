local M = {}

function M.setup()
  require('modes').setup({
    colors = {
      copy = '#e2a478',       -- yellow
      delete = '#e27878',     -- red
      insert = '#89b8c2',     -- cyan
      visual = '#a093c7',     -- purple
    },
    line_opacity = {
      copy = 0.15,
      delete = 0.15,
      insert = 0.15,
      visual = 0.25,
    }
  })
end

return M
