local M = {}

function M.setup()
  local palette = require('colors').palette
  local codicons = require('codicons')

  local theme = require('lualine.themes.catppuccin-frappe')
  theme.inactive.c.bg = palette.surface0

  require('lualine').setup({
    options = {
      icons_enabled = true,
      theme = theme,
      component_separators = '｜',
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
        { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
        { 'filename', padding = { left = 0, right = 1 } },
        { 'aerial',  dence = true }, -- the same as copmonent separator
      },
      lualine_x = { 'encoding' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  })
end

return M
