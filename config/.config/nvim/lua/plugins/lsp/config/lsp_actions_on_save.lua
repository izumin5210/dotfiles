---@param client vim.lsp.Client
---@param bufnr integer
local function format_sync(client, bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    async = false,
    name = client.name,
    timeout_ms = 5000,
  })
end

---@param client vim.lsp.Client
---@param bufnr integer
---@param cmd string
local function code_action_sync(client, bufnr, cmd)
  local enc = client and client.offset_encoding or "utf-16"
  local params = vim.lsp.util.make_range_params(0, enc)
  params.context = { only = { cmd }, diagnostics = {} }
  local res = client:request_sync("textDocument/codeAction", params, 3000, bufnr)
  for _, r in pairs(res and res.result or {}) do
    if r.edit then
      vim.lsp.util.apply_workspace_edit(r.edit, enc)
    end
  end
end

---@param client vim.lsp.Client
---@param bufnr integer
local function organize_imports_sync(client, bufnr)
  code_action_sync(client, bufnr, "source.organizeImports")
end

---@param client vim.lsp.Client
---@param bufnr integer
local function fix_all_sync(client, bufnr)
  code_action_sync(client, bufnr, "source.fixAll")
end

---@type table<string, fun(client: vim.lsp.Client, bufnr: integer)[]>
local lsp_actions_on_save = {
  gopls = { organize_imports_sync, format_sync },
  rust_analyzer = { format_sync },
  biome = { fix_all_sync, organize_imports_sync, format_sync },
  eslint = {
    function(client, bufnr)
      client:request_sync("workspace/executeCommand", {
        command = "eslint.applyAllFixes",
        arguments = {
          {
            uri = vim.uri_from_bufnr(bufnr),
            version = vim.lsp.util.buf_versions[bufnr],
          },
        },
      }, nil, bufnr)
    end,
  },
  buf_ls = { format_sync },
}

local formatters_to_skip = {
  "biome",
}

---@param args { buf: integer }
local function run_on_save(args)
  for _, client in pairs(vim.lsp.get_clients({ bufnr = args.buf })) do
    local funcs = lsp_actions_on_save[client.name]
    for _, f in pairs(funcs or {}) do
      f(client, args.buf)
    end
  end

  local conform = require("conform")
  ---@type string[]
  local formatter_names_to_run = {}
  for _, formatter in pairs(conform.list_formatters_to_run(args.buf)) do
    if not vim.tbl_contains(formatters_to_skip, formatter.name) then
      table.insert(formatter_names_to_run, formatter.name)
    end
  end
  conform.format({
    bufnr = args.buf,
    async = false,
    formatters = formatter_names_to_run,
  })
end

return run_on_save
