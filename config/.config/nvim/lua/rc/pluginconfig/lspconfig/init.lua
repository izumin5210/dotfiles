local M = {}

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

function M.init()
  local colors = require("rc.colors")
  local palette = colors.palette

  require("rc.utils").force_set_highlights("lspconfig_hl", {
    LspInlayHint = { link = "DiagnosticHint" },
    -- https://github.com/catppuccin/vscode/blob/catppuccin-vsc-v3.15.2/packages/catppuccin-vsc/src/theme/extensions/error-lens.ts
    DiagnosticErrorLine = { bg = colors.alpha_blend(palette.red, palette.base, 0.15) },
    DiagnosticWarnLine = { bg = colors.alpha_blend(palette.peach, palette.base, 0.15) },
    DiagnosticHintLine = { bg = colors.alpha_blend(palette.green, palette.base, 0.15) },
    DiagnosticInfoLine = { bg = colors.alpha_blend(palette.blue, palette.base, 0.15) },
  })

  vim.diagnostic.config({
    virtual_text = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅚 ",
        [vim.diagnostic.severity.WARN] = "󰀪 ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
        [vim.diagnostic.severity.INFO] = " ",
      },
      linehl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLine",
        [vim.diagnostic.severity.WARN] = "DiagnosticWarnLine",
        [vim.diagnostic.severity.HINT] = "DiagnosticHintLine",
        [vim.diagnostic.severity.INFO] = "DiagnosticInfoLine",
      },
    },
  })
end

function M.setup()
  local augroup = vim.api.nvim_create_augroup("neovim_lspconfig_setup", { clear = true })
  local utils = require("rc.pluginconfig.lspconfig.utils")

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    ---@param args { buf: integer }
    callback = function(args)
      local actions = require("rc.pluginconfig.lspconfig.lsp_actions_on_save")
      utils.run_lsp_actions(actions, { buf = args.buf })
    end,
  })

  ---@param client vim.lsp.Client
  ---@param bufnr integer
  local on_attach_lsp = function(client, bufnr)
    -- enable inlay hints by default
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

    local keymaps = require("rc.pluginconfig.lspconfig.lsp_keymaps").get_keymaps(bufnr)
    utils.register_keymaps(keymaps, { buf = bufnr })
  end

  local lspconfig = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")

  require("mason").setup()
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
          settings = require("rc.pluginconfig.lspconfig.lsp_settings")[server_name],
          filetypes = require("rc.pluginconfig.lspconfig.lsp_filetypes")[server_name],
          root_dir = lsp_root_dir[server_name],
          single_file_support = server_name ~= "tsserver" and nil or false,
          on_new_config = require("rc.pluginconfig.lspconfig.lsp_config_overrides")[server_name],
        })
      end,
    },
  })

  -- language servers are installed manually
  lspconfig.nixd.setup({
    on_attach = on_attach_lsp,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
  })

  -- Setup null-ls(none-ls)
  -- Primary Source of Truth is null-ls.
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      -- JavaScript
      null_ls.builtins.formatting.prettierd.with({
        condition = function(utils)
          return not utils.root_has_file({ "biome.json", "biome.jsonc", "deno.json", "deno.jsonc" })
        end,
      }),
      -- Protocol Buffers
      null_ls.builtins.diagnostics.buf,
      null_ls.builtins.formatting.buf,
      -- Dockerfile
      null_ls.builtins.diagnostics.hadolint,
      -- GitHub Actions
      null_ls.builtins.diagnostics.actionlint,
      -- ShellScript
      null_ls.builtins.formatting.shfmt.with({
        extra_args = { "-i", "2" },
      }),
      -- Lua
      null_ls.builtins.formatting.stylua,
      -- not supported by mason
      -- Nix
      null_ls.builtins.formatting.nixfmt,
    },
    debug = true,
  })
  require("mason-null-ls").setup({
    ensure_installed = nil,
    automatic_installation = true,
  })
end

return M
