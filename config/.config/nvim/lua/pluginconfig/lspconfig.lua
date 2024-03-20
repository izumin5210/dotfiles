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
    require('telescope.builtin').diagnostics({ bufnr = 0 })
  end,
}

-- https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
local tsserver_settings = {
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    -- includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = 'all',
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    -- includeInlayPropertyDeclarationTypeHints = true,
    -- includeInlayVariableTypeHints = true,
    -- includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  }
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
    }
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
          { 'clsx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          "(?:enter|leave)(?:From|To)?=\\s*(?:\"|')([^(?:\"|')]*)"
        }
      }
    }
  }
}

local lsp_filetypes = {
  graphql = { 'graphql', 'typescriptreact', 'javascriptreact', 'typescript', 'javascript', 'vue' },
}

function M.setup_null_ls()
  local augroup = vim.api.nvim_create_augroup('null_ls_setup', { clear = true })
  local null_ls = require('null-ls')
  null_ls.setup({
    sources = {
      -- JavaScript
      null_ls.builtins.formatting.prettier,
      -- Ppotocol Buffers
      null_ls.builtins.diagnostics.buf,
      null_ls.builtins.formatting.buf,
      -- Dockerfile
      null_ls.builtins.diagnostics.hadolint,
      -- GitHub Actions
      null_ls.builtins.diagnostics.actionlint,
      -- ShellScript
      null_ls.builtins.formatting.shfmt,
    },
    on_attach = function(client, bufnr)
      if client.supports_method('textDocument/formatting') then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              bufnr = bufnr,
              async = false,
              timeout_ms = 5000,
              name = 'null-ls',
            })
          end,
        })
      end
    end,
  })
end

function M.setup_mason()
  require('mason').setup()
end

function M.setup_mason_null_ls()
  require('mason-null-ls').setup({
    -- Primary Source of Truth is `null-ls`
    ensure_installed = nil,
    automatic_installation = true,
  })
end

function M.init_lsp_signature()
  local augroup = vim.api.nvim_create_augroup('lsp_signature_init', { clear = true })

  vim.api.nvim_create_autocmd('Colorscheme', {
    group = augroup,
    pattern = '*',
    command = 'highlight link LspSignatureActiveParameter Todo'
  })
end

function M.setup_lsp_signature()
  require('lsp_signature').setup({
    hint_enable = false,
  })
end

function M.setup_lspsaga()
  require('lspsaga').setup({
    symbol_in_winbar = { enable = false },
    code_action = { show_server_name = true, }
  })
end

function M.init()
  local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight link LspInlayHint DiagnosticHint',
  })
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup('neovim_lspconfig_setup', { clear = true })

  -- https://github.com/neovim/nvim-lspconfig/tree/v0.1.5#suggested-configuration
  local on_attach_lsp = function(client, bufnr)
    local ts_builtin = require('telescope.builtin')

    local list_workspace_folders = function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end
    local format = function()
      vim.lsp.buf.format({ async = true, bufnr = bufnr, timeout_ms = 10000, name = client.name })
    end
    local show_diagnostics = function()
      require('telescope.builtin').diagnostics({ bufnr = 0 })
    end

    local keys = {
      -- see global mappings in https://github.com/neovim/nvim-lspconfig#suggested-configuration
      { 'n',          '<space>e',  '<cmd>Lspsaga show_line_diagnostics<CR>', desc = 'Show Line Diagnostics' },
      { 'n',          '[d',        '<cmd>Lspsaga diagnostic_jump_prev<CR>',  desc = 'Go to prev Diagnostic' },
      { 'n',          ']d',        '<cmd>Lspsaga diagnostic_jump_next<CR>',  desc = 'Go to next Diagnostic' },
      { 'n',          '<space>q',  show_diagnostics,                         desc = 'Show Diagnostics in Document' },
      -- see buffer lcoal mappings in https://github.com/neovim/nvim-lspconfig#suggested-configuration
      { 'n',          'gD',        vim.lsp.buf.declaration,                  desc = 'Go to Declarations' },
      { 'n',          'gd',        ts_builtin.lsp_definitions,               desc = 'Go to Definitions' },
      { 'n',          'K',         '<cmd>Lspsaga hover_doc<CR>',             desc = 'Show Hover Card' },
      { 'n',          'gi',        ts_builtin.lsp_implementations,           desc = 'Go to Implementations' },
      { { 'n', 'i' }, '<C-k>',     vim.lsp.buf.signature_help,               desc = 'Show Signature Help' },
      { 'n',          '<space>wa', vim.lsp.buf.add_workspace_folder,         desc = 'Add Workspace Folder' },
      { 'n',          '<space>wr', vim.lsp.buf.remove_workspace_folder,      desc = 'Remove Workspace Folder' },
      { 'n',          '<space>wl', list_workspace_folders,                   desc = 'List Workspace Folders' },
      { 'n',          '<space>D',  ts_builtin.lsp_type_definitions,          desc = 'Go to Type Definitions' },
      { 'n',          '<space>rn', '<cmd>Lspsaga rename ++project<CR>',      desc = 'Rename Symbol' },
      { { 'n', 'v' }, '<space>.',  '<cmd>Lspsaga code_action<CR>',           desc = 'Code Action' },
      { 'n',          'gr',        ts_builtin.lsp_references,                desc = 'Go to References' },
      { 'n',          '<space>f',  format,                                   desc = 'Format Document' },
      -- custom mappings
      { 'n',          'gs',        ts_builtin.lsp_document_symbols,          desc = 'Go to Symbols in Document' },
      { 'n',          'gS',        ts_builtin.lsp_dynamic_workspace_symbols, desc = 'Search Symbols in Workspace' },
      { 'n',          'gci',       ts_builtin.lsp_incoming_calls,            desc = 'Incoming Calls' },
      { 'n',          'gco',       ts_builtin.lsp_outgoing_calls,            desc = 'Outgoing Calls' },
    }

    if vim.lsp.inlay_hint then
      table.insert(keys, { 'n', '<leader>uh', function() vim.lsp.inlay_hint(bufnr, nil) end, desc = 'Toggle Inlay Hints' })

      -- enable inlay hints by default
      vim.lsp.inlay_hint(bufnr, true)
    end

    for _, km in pairs(keys) do
      vim.keymap.set(km[1], km[2], km[3],
        { noremap = true, silent = true, buffer = bufnr, desc = 'LSP: ' .. km.desc })
    end

    if client.name == 'gopls' or client.name == 'rust_analyzer' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            async = false,
            name = client.name,
            timeout_ms = 5000
          })
        end,
      })
    end
    if client.name == 'gopls' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- https://github.com/golang/tools/blob/gopls/v0.11.0/gopls/doc/vim.md#imports
          local params = vim.lsp.util.make_range_params()
          params.context = { only = { 'source.organizeImports' } }
          local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 3000)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
        end
      })
    end
    if client.name == 'eslint' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        command = 'silent! EslintFixAll',
      })
    end
  end

  local lspconfig = require('lspconfig')
  local mason_lspconfig = require('mason-lspconfig')

  mason_lspconfig.setup({
    ensure_installed = {
      'bashls',
      'bufls',
      'dockerls',
      'graphql',
      'jsonnet_ls',
      'rust_analyzer',
      -- Nix
      'nil',
      -- Ruby
      'solargraph',
      -- JS
      'eslint',
      'tsserver',
      'volar',
      -- CSS
      'cssls',
      'tailwindcss',
      -- Go
      'gopls',
      'golangci_lint_ls',
      -- Python
      'pyright',
      -- Lua
      'lua_ls',
      -- JSON (JSON Schema)
      'jsonls',
      'yamlls'
    },
    automatic_installation = true,
    handlers = {
      function(server_name)
        lspconfig[server_name].setup({
          on_attach = on_attach_lsp,
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
          settings = lsp_settings[server_name],
          filetypes = lsp_filetypes[server_name]
        })
      end,
    }
  })
end

return M
