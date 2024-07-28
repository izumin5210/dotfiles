vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = ".env.*",
  callback = function()
    vim.bo.filetype = "sh"
  end,
  once = false,
})
