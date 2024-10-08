if not vim.g.vscode then
  require("utils.highlight").set_highlights("hl_for_non_vscode", {
    -- clear statusline
    StatusLine = { link = "LineNr" },
    StatusLineNc = { link = "LineNr" },
    -- clear bg
    Normal = { ctermbg = "none", bg = "none" },
    NonText = { ctermbg = "none", bg = "none" },
    LineNr = { ctermbg = "none", bg = "none" },
    Folded = { ctermbg = "none", bg = "none" },
    EndOfBuffer = { ctermbg = "none", bg = "none" },
  })

  require("utils.highlight").force_set_highlights("force_hl_for_non_vscode", {
    DiagnosticHint = { link = "LineNr" },
    -- reset semantic highlight
    ["@lsp.type.variable"] = {},
    ["@lsp.type.parameter"] = {},
    ["@lsp.type.property"] = {},
    ["@lsp.type.function"] = {},
  })

  local palette = require("utils.colors").palette
  require("utils.highlight").set_highlights("catppuccin_hl", {
    NormalFloat = { bg = palette.crust },
    FloatBorder = { bg = palette.crust },
  })
end
