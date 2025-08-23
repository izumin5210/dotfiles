-- https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
local ts_ls_settings = {
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    -- includeInlayFunctionLikeReturnTypeHints = true,
    -- includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    -- includeInlayPropertyDeclarationTypeHints = true,
    -- includeInlayVariableTypeHints = true,
    -- includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  },
}

---@type vim.lsp.Config
local config = {
  settings = {
    javascript = ts_ls_settings,
    typescript = ts_ls_settings,
    javascriptreact = ts_ls_settings,
    typescriptreact = ts_ls_settings,
  },
}

return config
