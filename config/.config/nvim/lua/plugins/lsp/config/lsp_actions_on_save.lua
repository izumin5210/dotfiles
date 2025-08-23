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
  -- https://github.com/golang/tools/blob/gopls/v0.11.0/gopls/doc/vim.md#imports
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { cmd }, diagnostics = {} }
  local res = client.request_sync("textDocument/codeAction", params, 3000, bufnr)
  for _, r in pairs(res and res.result or {}) do
    if r.edit then
      local enc = (vim.lsp.get_client_by_id(client.id) or {}).offset_encoding or "utf-16"
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
  denols = { format_sync },
  ["null-ls"] = { format_sync },
}

return lsp_actions_on_save
