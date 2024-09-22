local M = {}

function M.opts()
  local devicons = require("nvim-web-devicons")
  local palette = require("utils.colors").palette

  -- local fg_active = palette.text
  local fg_active = palette.mauve
  local fg_inactive = palette.overlay0
  local icons = { error = "󰅚 ", warn = "󰀪 ", hint = "󰌶 ", info = " " }

  --- @param props { buf: number, win: number, focused: boolean }
  local function get_diagnostic_label(props)
    local label = {}

    for severity, icon in pairs(icons) do
      local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
      if n > 0 then
        table.insert(label, {
          icon .. n .. " ",
          group = props.focused and ("DiagnosticSign" .. severity) or "NonText",
        })
      end
    end
    if #label > 0 then
      table.insert(label, { "┊ ", guifg = fg_inactive })
    end
    return label
  end

  -- based on https://github.com/b0o/incline.nvim/discussions/32
  --- @param props { buf: number, win: number, focused: boolean }
  local function render(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if filename == "" then
      filename = "[No Name]"
    end
    local ft_icon, ft_color = devicons.get_icon_color(filename)

    local hasError = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity["ERROR"] }) > 0

    return {
      { get_diagnostic_label(props) },
      {
        (ft_icon and ft_icon .. " " or ""),
        guifg = props.focused and ft_color or fg_inactive,
      },
      {
        filename,
        guifg = props.focused and (hasError and palette.red or fg_active) or fg_inactive,
        gui = props.focused and "bold" or "",
      },
      {
        vim.bo[props.buf].modified and " ●" or "",
        guifg = props.focused and palette.peach or fg_inactive,
      },
    }
  end

  return {
    highlight = {
      groups = {
        InclineNormal = { guibg = palette.mantle, guifg = fg_active },
        InclineNormalNC = { guibg = "none", guifg = fg_inactive },
      },
    },
    window = {
      options = {
        winblend = 0,
      },
      placement = {
        horizontal = "right",
        vertical = "bottom",
      },
      margin = { horizontal = 0, vertical = 0 },
      padding = 2,
    },
    render = render,
  }
end

return M
