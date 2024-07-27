local M = {}

function M.setup()
  local wk = require("which-key")
  wk.setup({
    plugins = {
      presets = {
        operators = false,
      },
    },
  })
  wk.add({
    { "<leader>g", group = "+Go to File, Code or GitHub" },
    { "<leader>t", group = "+Test" },
    { "<leader>d", group = "+Debug" },
    { "<leader>c", group = "+Comment" },
  })
end

return M
