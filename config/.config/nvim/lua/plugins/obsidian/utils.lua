local M = {}

---@param buf number
---@return boolean
function M.is_md(buf)
  if not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  if vim.bo[buf].filetype ~= "markdown" then
    return false
  end

  return true
end

---@param buf number
---@return boolean
function M.is_in_vault(buf)
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p")
  local enable = string.match(path, "^" .. vim.pesc(Obsidian.dir.filename) .. "/")
  return enable ~= nil
end

return M
