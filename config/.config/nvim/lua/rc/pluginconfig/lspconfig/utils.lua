local M = {}

---@param actions_by_client_name table<string, fun(client: vim.lsp.Client, bufnr: integer)[]>
---@param args { buf: integer }
function M.run_lsp_actions(actions_by_client_name, args)
  local bufnr = args.buf
  local shouldSleep = false
  for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    local actions = actions_by_client_name[client.name]
    for _, f in pairs(actions or {}) do
      if shouldSleep then
        vim.api.nvim_command("sleep 10ms")
      else
        shouldSleep = true
      end
      f(client, bufnr)
    end
  end
end

---@param keymaps { [1]: string|string[], [2]: string, [3]: string | function, desc: string }[]
---@param args { buf: integer }
function M.register_keymaps(keymaps, args)
  for _, km in pairs(keymaps) do
    vim.keymap.set(km[1], km[2], km[3], { noremap = true, silent = true, buffer = args.buf, desc = "LSP: " .. km.desc })
  end
end

---@return "npm"|"yarn"|"pnpm"|nil
function M.detect_node_package_manager()
  local lspconfig = require("lspconfig")

  local startpath = vim.api.nvim_buf_get_name(0)
  local npm = lspconfig.util.root_pattern("package-lock.json")(startpath)
  local yarn = lspconfig.util.root_pattern("yarn.lock")(startpath)
  local pnpm = lspconfig.util.root_pattern("pnpm-lock.yml", "pnpm-lock.yaml")(startpath)

  ---@type { [1]: "npm"|"yarn"|"pnpm", [2]: number } | nil
  local detected = nil
  for _, cmd in pairs({
    { "npm", string.len(npm or "") },
    { "yarn", string.len(yarn or "") },
    { "pnpm", string.len(pnpm or "") },
  }) do
    if cmd[2] > 0 and (detected == nil or cmd[2] > detected[2]) then
      detected = cmd
    end
  end

  return detected and detected[1]
end

return M
