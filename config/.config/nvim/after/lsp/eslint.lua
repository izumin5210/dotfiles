local utils = require("plugins.lsp.config.utils")

---@type vim.lsp.Config
local config = {
  filetypes = utils.append_filetypes("eslint", { "graphql" }),
}

return config
