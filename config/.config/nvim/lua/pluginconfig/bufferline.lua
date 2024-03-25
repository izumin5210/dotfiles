local M = {}

function M.setup()
  local palette = require('colors').palette

  local hl_selected = { bg = 'none', italic = false, bold = true }
  local hl_normal_fg = { highlight = 'Normal', attribute = 'fg' }
  local hl_comment_fg = { highlight = 'Comment', attribute = 'fg' }
  local hl_separator = { fg = palette.surface1, bg = 'none' }

  require('bufferline').setup({
    options = {
      middle_mouse_command = 'bdelete! %d',     -- same as close_command
      indicator = { style = 'none' },           -- hide current buffer indicator
      diagnostics = 'nvim_lsp',
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        if context.buffer:current() then     -- hide diagnostics indicator for the current buffer
          return ''
        end
        local icon = level:match('error') and ' ' or ' '
        return ' ' .. icon .. count
      end,
      show_close_icon = false,
      separator_style = 'thin',
      hover = { enabled = false },
    },
    highlights = {
      fill = { bg = 'none' },
      background = { bg = 'none' },
      tab = { bg = 'none' },
      tab_selected = vim.tbl_extend('keep', { fg = hl_normal_fg }, hl_selected),
      tab_close = { bg = 'none' },
      tab_separator = hl_separator,
      tab_separator_selected = hl_separator,
      buffer_visible = { bg = 'none' },
      buffer_selected = hl_selected,
      diagnostic = { bg = 'none' },
      diagnostic_visible = { bg = 'none' },
      diagnostic_selected = hl_selected,
      hint = { bg = 'none' },
      hint_visible = { bg = 'none' },
      hint_selected = hl_selected,
      hint_diagnostic = { bg = 'none' },
      hint_diagnostic_visible = { bg = 'none' },
      hint_diagnostic_selected = hl_selected,
      info = { bg = 'none' },
      info_visible = { bg = 'none' },
      info_selected = hl_selected,
      info_diagnostic = { bg = 'none' },
      info_diagnostic_visible = { bg = 'none' },
      info_diagnostic_selected = hl_selected,
      warning = { bg = 'none' },
      warning_visible = { bg = 'none' },
      warning_selected = hl_selected,
      warning_diagnostic = { bg = 'none' },
      warning_diagnostic_visible = { bg = 'none' },
      warning_diagnostic_selected = hl_selected,
      error = { bg = 'none' },
      error_visible = { bg = 'none' },
      error_selected = hl_selected,
      error_diagnostic = { bg = 'none' },
      error_diagnostic_visible = { bg = 'none' },
      error_diagnostic_selected = hl_selected,
      modified = { fg = hl_comment_fg, bg = 'none' },
      modified_visible = { fg = hl_comment_fg, bg = 'none' },
      modified_selected = vim.tbl_extend('keep', { fg = hl_normal_fg }, hl_selected),
      duplicate_selected = hl_selected,
      duplicate_visible = { bg = 'none' },
      duplicate = { bg = 'none' },
      separator_selected = hl_separator,
      separator_visible = hl_separator,
      separator = hl_separator,
      indicator_selected = { bg = 'none' },
      pick_selected = { bg = 'none' },
      pick_visible = { bg = 'none' },
      pick = { bg = 'none' },
    }
  })
end

return M
