local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vim.fs.joinpath(vim.env.DOTFILES_DIR, "node_modules", "@vue", "language-server"),
  languages = { "vue" },
  configNamespace = "typescript",
}

local ts_ls_settings = {
  suggest = {
    completeFunctionCalls = true,
  },
  -- https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
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

local utils = require("plugins.lsp.config.utils")

---@type vim.lsp.Config
local config = {
  settings = {
    vtsls = {
      -- enableMoveToFileCodeAction = true,
      -- autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
    javascript = ts_ls_settings,
    typescript = ts_ls_settings,
    javascriptreact = ts_ls_settings,
    typescriptreact = ts_ls_settings,
  },
  on_attach = utils.wrap_on_attach(function(client, bufnr)
    if vim.bo.filetype == "vue" then
      client.server_capabilities.semanticTokensProvider.full = false
    else
      client.server_capabilities.semanticTokensProvider.full = true
    end
  end),
  filetypes = utils.append_filetypes("vtsls", { "vue" }),
}

return config
