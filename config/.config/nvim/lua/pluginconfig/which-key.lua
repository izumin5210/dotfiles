local M = {}

function M.setup()
  require('which-key').setup({
    plugins = {
      presets = {
        operators = false,
      },
    },
  })
  require('which-key').register({
    ['<leader>g'] = { name = '+Go to File, Code or GitHub' },
    ['<leader>t'] = { name = '+Test' },
    ['<leader>d'] = { name = '+Debug' },
    ['<leader>c'] = { name = '+Comment' },
  })
end

return M
