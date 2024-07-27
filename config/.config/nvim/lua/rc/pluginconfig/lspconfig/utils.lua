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

return M
