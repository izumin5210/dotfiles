local M = {}

M.actions = {
  list_workspace_folders = function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end,
  ---@param opt { bufnr: any, client_name: string }
  format = function(opt)
    vim.lsp.buf.format({ async = true, bufnr = opt.bufnr, timeout_ms = 10000, name = opt.client_name })
  end,
  show_diagnostics = function()
    require("telescope.builtin").diagnostics({ bufnr = 0 })
  end,
}

-- https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
local tsserver_settings = {
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    -- includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
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

local lsp_filetypes = {
  graphql = { "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript", "vue" },
}

---@param fname string
---@return {node_root: string|nil, deno_root: string|nil}
local function detect_node_or_deno_root(fname)
  local util = require("lspconfig.util")
  local node_root = util.root_pattern("tsconfig.json", "package.json", "jsconfig.json")(fname)
  local deno_root = util.root_pattern("deno.json", "deno.jsonc")(fname)

  if deno_root == nil then
    return { node_root = node_root, deno_root = nil }
  end

  if node_root == nil then
    return { node_root = nil, deno_root = deno_root }
  end

  if string.len(vim.fs.dirname(node_root)) > string.len(vim.fs.dirname(deno_root)) then
    return { node_root = node_root, deno_root = nil }
  end

  return { node_root = nil, deno_root = deno_root }
end

local lsp_root_dir = {
  ---@param fname string
  ---@return string|nil
  tsserver = function(fname)
    local res = detect_node_or_deno_root(fname)
    return res.node_root
  end,
  ---@param fname string
  ---@return string|nil
  denols = function(fname)
    local res = detect_node_or_deno_root(fname)
    return res.deno_root
  end,
}

function M.setup_null_ls()
  local augroup = vim.api.nvim_create_augroup("null_ls_setup", { clear = true })
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      -- not supported by mason
      null_ls.builtins.formatting.nixfmt,
    },
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              async = false,
              timeout_ms = 5000,
              name = "null-ls",
            })
          end,
        })
      end
    end,
  })
end

function M.setup_mason_null_ls()
  require("mason-null-ls").setup({
    ensure_installed = {
      "prettierd", -- JavaScript
      "buf", -- Protocol Buffers
      "hadolint", -- Dockerfile
      "actionlint", -- GitHub Actions
      "shfmt", -- ShellScript
      "stylua", -- Lua
    },
    automatic_installation = false,
    handlers = {
      prettierd = function(source_name, methods)
        local null_ls = require("null-ls")
        null_ls.register(null_ls.builtins.formatting.prettierd.with({
          condition = function(utils)
            return not utils.root_has_file({ "biome.json", "biome.jsonc" })
          end,
        }))
      end,
      shfmt = function(source_name, methods)
        local null_ls = require("null-ls")
        null_ls.register(null_ls.builtins.formatting.shfmt.with({
          extra_args = { "-i", "2" },
        }))
      end,
    },
  })
end

function M.init_lsp_signature()
  require("utils").force_set_highlights("lsp_signature_init_hl", {
    LspSignatureActiveParameter = { link = "Todo" },
  })
end

function M.setup_lsp_signature()
  require("lsp_signature").setup({
    hint_enable = false,
    handler_opts = {
      -- create padding around the floating window
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
    },
  })
end

function M.init_lspsaga()
  local palette = require("colors").palette
  require("utils").set_highlights("lspsaga_hl", {
    SagaNormal = { bg = palette.crust },
    SagaBorder = { bg = palette.crust },
  })
end

function M.setup_lspsaga()
  require("lspsaga").setup({
    symbol_in_winbar = { enable = false },
    code_action = { show_server_name = true },
    ui = {
      -- create padding around the floating window
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
    },
  })
end

function M.init()
  local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  require("utils").force_set_highlights("lspconfig_hl", {
    LspInlayHint = { link = "DiagnosticHint" },
  })
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("neovim_lspconfig_setup", { clear = true })

  -- https://github.com/neovim/nvim-lspconfig/tree/v0.1.5#suggested-configuration
  local on_attach_lsp = function(client, bufnr)
    local ts_builtin = require("telescope.builtin")

    local format = function()
      vim.lsp.buf.format({ async = true, bufnr = bufnr, timeout_ms = 10000, name = client.name })
    end
    local show_diagnostics = function()
      require("telescope.builtin").diagnostics({ bufnr = 0 })
    end
    ---@param is_next'next'|'prev'
    ---@param severity 'ERROR'|'WARN'|nil
    local get_diagnostic_goto = function(is_next, severity)
      return function()
        severity = vim.diagnostic.severity[severity]
        if is_next == "next" then
          require("lspsaga.diagnostic"):goto_next({ severity = severity })
        else
          require("lspsaga.diagnostic"):goto_prev({ severity = severity })
        end
      end
    end

    local keys = {
      -- see global mappings in https://github.com/neovim/nvim-lspconfig#suggested-configuration
      { "n", "<space>e", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show Line Diagnostics" },
      { "n", "[d", get_diagnostic_goto("prev"), desc = "Go to prev Diagnostic" },
      { "n", "]d", get_diagnostic_goto("next"), desc = "Go to next Diagnostic" },
      { "n", "[e", get_diagnostic_goto("prev", "ERROR"), desc = "Go to prev Error" },
      { "n", "]e", get_diagnostic_goto("next", "ERROR"), desc = "Go to next Error" },
      { "n", "[w", get_diagnostic_goto("prev", "WARN"), desc = "Go to prev Diagnostic(warn)" },
      { "n", "]w", get_diagnostic_goto("next", "WARN"), desc = "Go to next Diagnostic(warn)" },
      { "n", "<space>q", show_diagnostics, desc = "Show Diagnostics in Document" },
      -- see buffer lcoal mappings in https://github.com/neovim/nvim-lspconfig#suggested-configuration
      { "n", "gD", vim.lsp.buf.declaration, desc = "Go to Declarations" },
      { "n", "gd", ts_builtin.lsp_definitions, desc = "Go to Definitions" },
      { "n", "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Show Hover Card" },
      { "n", "gi", ts_builtin.lsp_implementations, desc = "Go to Implementations" },
      { { "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, desc = "Show Signature Help" },
      { "n", "<space>D", ts_builtin.lsp_type_definitions, desc = "Go to Type Definitions" },
      { "n", "<space>rn", "<cmd>Lspsaga rename ++project<CR>", desc = "Rename Symbol" },
      { { "n", "v" }, "<space>.", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
      { "n", "gr", ts_builtin.lsp_references, desc = "Go to References" },
      { "n", "<space>f", format, desc = "Format Document" },
      -- custom mappings
      { "n", "gs", ts_builtin.lsp_document_symbols, desc = "Go to Symbols in Document" },
      { "n", "gS", ts_builtin.lsp_dynamic_workspace_symbols, desc = "Search Symbols in Workspace" },
      { "n", "gci", ts_builtin.lsp_incoming_calls, desc = "Incoming Calls" },
      { "n", "gco", ts_builtin.lsp_outgoing_calls, desc = "Outgoing Calls" },
    }

    if vim.lsp.inlay_hint then
      table.insert(keys, {
        "n",
        "<leader>uh",
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
        end,
        desc = "Toggle Inlay Hints",
      })

      -- enable inlay hints by default
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    for _, km in pairs(keys) do
      vim.keymap.set(km[1], km[2], km[3], { noremap = true, silent = true, buffer = bufnr, desc = "LSP: " .. km.desc })
    end

    if client.name == "gopls" or client.name == "rust_analyzer" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            async = false,
            name = client.name,
            timeout_ms = 5000,
          })
        end,
      })
    end
    if client.name == "gopls" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- https://github.com/golang/tools/blob/gopls/v0.11.0/gopls/doc/vim.md#imports
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { "source.organizeImports" } }
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
        end,
      })
    end
    if client.name == "eslint" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        command = "silent! EslintFixAll",
      })
    end
  end

  local lspconfig = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")

  mason_lspconfig.setup({
    ensure_installed = {
      "bashls",
      "bufls",
      "dockerls",
      "graphql",
      "jsonnet_ls",
      "rust_analyzer",
      -- Ruby
      "solargraph",
      -- JS
      "biome",
      "eslint",
      "tsserver",
      "volar",
      "prismals",
      "denols",
      -- CSS
      "cssls",
      "tailwindcss",
      -- Go
      "gopls",
      "golangci_lint_ls",
      -- Python
      "pyright",
      -- Lua
      "lua_ls",
      -- JSON (JSON Schema)
      "jsonls",
      "yamlls",
    },
    automatic_installation = false,
    handlers = {
      function(server_name)
        lspconfig[server_name].setup({
          on_attach = on_attach_lsp,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          settings = lsp_settings[server_name],
          filetypes = lsp_filetypes[server_name],
          root_dir = lsp_root_dir[server_name],
          single_file_support = server_name ~= "tsserver" and nil or false,
        })
      end,
    },
  })

  -- language servers are installed manually
  lspconfig.nixd.setup({
    on_attach = on_attach_lsp,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  })
end

return M
