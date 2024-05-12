local M = {}

function M.init()
  local palette = require('colors').palette
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = string.format('highlight InclineNormal guibg=%s blend=0', palette.base),
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = string.format('highlight InclineNormalNC guibg=%s blend=0', palette.base),
  })
end

function M.setup()
  local devicons = require('nvim-web-devicons')
  local palette = require('colors').palette

  require('incline').setup({
    -- based on https://github.com/b0o/incline.nvim/discussions/32
    render = function(props)
      local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
      if filename == '' then
        filename = '[No Name]'
      end
      local ft_icon, ft_color = devicons.get_icon_color(filename)

      local function get_diagnostic_label()
        local icons = { error = '󰅚 ', warn = '󰀪 ', hint = '󰌶 ', info = ' ' }
        local label = {}

        for severity, icon in pairs(icons) do
          local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
          if n > 0 then
            table.insert(label, {
              icon .. n .. ' ',
              group = props.focused and ('DiagnosticSign' .. severity) or 'NonText',
            })
          end
        end
        if #label > 0 then
          table.insert(label, { '┊ ' })
        end
        return label
      end

      return {
        { get_diagnostic_label() },
        { (ft_icon or '') .. ' ', guifg = ft_color, guibg = 'none' },
        {
          filename .. ' ' .. (vim.bo[props.buf].modified and '● ' or ''),
          guifg = props.focused and palette.text or palette.overlay0,
          gui = props.focused and 'bold' or '',
        },
      }
    end,
  })
end

return M
