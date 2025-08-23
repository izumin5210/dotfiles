---@type vim.lsp.Config
local config = {
  settings = {
    gopls = {
      gofumpt = true,
      semanticTokens = true,
      usePlaceholders = true,
      hints = {
        -- assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        -- functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}

return config
