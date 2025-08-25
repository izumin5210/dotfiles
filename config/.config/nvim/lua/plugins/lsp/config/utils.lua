local M = {}

---@param server_name string
---@param filetypes string[]
---@return string[]
function M.append_filetypes(server_name, filetypes)
  return vim.list_extend(require("lspconfig.configs." .. server_name).default_config.filetypes, filetypes)
end

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
local function register_keymaps(keymaps, args)
  for _, km in pairs(keymaps) do
    vim.keymap.set(km[1], km[2], km[3], { noremap = true, silent = true, buffer = args.buf, desc = "LSP: " .. km.desc })
  end
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach_common(client, bufnr)
  -- enable inlay hints by default
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

  local keymaps = require("plugins.lsp.config.lsp_keymaps").get_keymaps(bufnr)
  register_keymaps(keymaps, { buf = bufnr })
end

---@param on_attach fun(client: vim.lsp.Client, bufnr: integer)
---@return fun(client: vim.lsp.Client, bufnr: integer)
function M.wrap_on_attach(on_attach)
  return function(client, bufnr)
    M.on_attach_common(client, bufnr)
    on_attach(client, bufnr)
  end
end

return M
