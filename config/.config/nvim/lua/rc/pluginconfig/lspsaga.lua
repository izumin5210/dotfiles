local M = {}

function M.init()
  local palette = require("rc.colors").palette
  require("rc.utils").set_highlights("lspsaga_hl", {
    SagaNormal = { bg = palette.crust },
    SagaBorder = { bg = palette.crust },
  })
end

function M.opts()
  return {
    symbol_in_winbar = { enable = false },
    code_action = { show_server_name = true },
    ui = {
      -- create padding around the floating window
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
    },
  }
end

return M
