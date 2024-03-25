local M = {}

function M.setup()
  local palette = require('colors').palette
  local codicons = require('codicons')

  require('lualine').setup({
    options = {
      icons_enabled = true,
      theme = 'iceberg',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        { 'branch', cond = function() return vim.env.TMUX == nil end }, -- hide on tmux
        'diff',
        'diagnostics',
      },
      lualine_c = {
        {
          require('pluginconfig.dap').status,
          icon = { codicons.get('debug') },
          cond = require('pluginconfig.dap').is_loaded,
          color = { fg = palette.teal }
        },
        'filename',
        { 'aerial',      sep = '  ', dence = true }, -- the same as copmonent separator
        { 'lsp_progress' }
      },
      lualine_x = { 'encoding' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  })
end

return M
