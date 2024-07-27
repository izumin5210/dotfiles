---@type table<string, fun(config: lspconfig.Config)>
local on_new_config_by_client_name = {
  -- use project-local biome
  biome = function(new_config)
    local utils = require("rc.pluginconfig.lspconfig.utils")
    local pm = utils.detect_node_package_manager()
    if pm == nil then
      return
    end

    new_config.cmd = ({
      npm = { "npm", "exec", "biome", "lsp-proxy" },
      yarn = { "yarn", "biome", "lsp-proxy" },
      pnpm = { "pnpm", "biome", "lsp-proxy" },
    })[pm]
  end,
}

return on_new_config_by_client_name
