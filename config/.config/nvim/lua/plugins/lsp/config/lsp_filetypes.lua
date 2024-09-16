-- stylua: ignore
local defaults = {
  eslint = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", "svelte", "astro" },
  graphql = { "graphql", "typescriptreact", "javascriptreact" },
}

local lsp_filetypes = {
  graphql = vim.list_extend({ "typescript", "javascript", "vue" }, defaults.graphql),
  eslint = vim.list_extend({ "graphql" }, defaults.eslint),
}

return lsp_filetypes
