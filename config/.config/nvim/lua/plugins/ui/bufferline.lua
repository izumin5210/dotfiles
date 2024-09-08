local M = {}

local function get_highlights()
  local palette = require("rc.colors").palette
  local inactive_hl = { fg = palette.surface2 }
  local active_hl = { bold = true }
  local custom_highlights = {
    background = inactive_hl,
    buffer_visible = inactive_hl,
    buffer_selected = active_hl,
    offset_separator = { fg = palette.surface1 },
    trunc_marker = { bg = "none", fg = palette.surface2 },
  }
  for _, lv in pairs({ "error", "warning", "info", "hint" }) do
    custom_highlights = vim.tbl_deep_extend("keep", custom_highlights, {
      [lv] = inactive_hl,
      [lv .. "_visible"] = inactive_hl,
      [lv .. "_selected"] = active_hl,
      [lv .. "_diagnostic"] = inactive_hl,
      [lv .. "_diagnostic_visible"] = inactive_hl,
      [lv .. "_diagnostic_selected"] = active_hl,
    })
  end

  return require("catppuccin.groups.integrations.bufferline").get({
    styles = { "bold" },
    custom = { all = custom_highlights },
  })
end

---@param count number
---@param level "error"|"warning"
---@param diagnostics_dict table<"error"|"warning"|"info", number>
---@return string
local function diagnostics_indicator(count, level, diagnostics_dict)
  local symbols = { error = "󰅚 ", warning = "󰀪 ", hint = "󰌶 ", info = " " }
  local chunks = {}
  for _, lv in pairs({ "error", "warning", "hint", "info" }) do
    local n = diagnostics_dict[lv] or 0
    if n > 0 then
      table.insert(chunks, symbols[lv] .. n)
    end
  end
  return table.concat(chunks, " ")
end

---@param bufnum number
local function close_command(bufnum)
  require("bufdelete").bufdelete(bufnum, true)
end

function M.opts()
  return {
    highlights = get_highlights(),
    options = {
      right_mouse_command = nil,
      middle_mouse_command = close_command,
      indicator = { style = "none" },
      ---@param buf { name: string, path: string, bufnr: number }
      ---@return string
      name_formatter = function(buf)
        local name = buf.name
        local bo = vim.bo[buf.bufnr]
        if bo and bo.readonly then
          name = " " .. name -- nf-fa-lock
        end

        return name
      end,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = diagnostics_indicator,
      offsets = {
        {
          filetype = "NvimTree",
          text = "",
          highlight = "Constant",
          separator = true,
        },
      },
      show_buffer_close_icons = false,
      separator_style = "thin",
      hover = { enabled = false },
    },
  }
end

return M
