local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function M.toggle_lazygit()
  lazygit:toggle()
end

return M
