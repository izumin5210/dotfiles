-- https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
local tsserver_settings = {
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

local lsp_settings = {
  gopls = {
    gopls = {
      semanticTokens = true,
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
  tsserver = {
    javascript = tsserver_settings,
    typescript = tsserver_settings,
    javascriptreact = tsserver_settings,
    typescriptreact = tsserver_settings,
  },
  lua_ls = {
    Lua = {
      hint = { enable = true },
    },
  },
  tailwindcss = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          -- https://github.com/paolotiu/tailwind-intellisense-regex-list
          { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          "(?:enter|leave)(?:From|To)?=\\s*(?:\"|')([^(?:\"|')]*)",
        },
      },
    },
  },
}

return lsp_settings
