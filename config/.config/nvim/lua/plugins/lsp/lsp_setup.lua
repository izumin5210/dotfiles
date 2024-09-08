local lsp_root_dir = {
  ---@param fname string
  ---@return string|nil
  tsserver = function(fname)
    local res = require("plugins.lsp.utils").detect_node_or_deno_root(fname)
    return res.node_root
  end,
  ---@param fname string
  ---@return string|nil
  denols = function(fname)
    local res = require("plugins.lsp.utils").detect_node_or_deno_root(fname)
    return res.deno_root
  end,
}
---@param client vim.lsp.Client
---@param bufnr integer
local on_attach_lsp = function(client, bufnr)
  local utils = require("plugins.lsp.utils")

  -- enable inlay hints by default
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

  local keymaps = require("plugins.lsp.lsp_keymaps").get_keymaps(bufnr)
  utils.register_keymaps(keymaps, { buf = bufnr })
end

---@param server_name string
local function lsp_setup(server_name)
  require("lspconfig")[server_name].setup({
    on_attach = on_attach_lsp,
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = require("plugins.lsp.lsp_settings")[server_name],
    filetypes = require("plugins.lsp.lsp_filetypes")[server_name],
    root_dir = lsp_root_dir[server_name],
    single_file_support = server_name ~= "tsserver" and nil or false,
    on_new_config = require("plugins.lsp.lsp_config_overrides")[server_name],
  })
end

return lsp_setup
