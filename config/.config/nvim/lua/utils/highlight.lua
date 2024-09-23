local M = {}

---@param gname string group_name
---@param f fun()
local function update_highlights(gname, f)
  f()
  local group = vim.api.nvim_create_augroup(gname, { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    group = group,
    callback = function()
      f()
    end,
  })
end

---@param gname string group_name
---@param highlights table<string, vim.api.keyset.highlight>
function M.set_highlights(gname, highlights)
  update_highlights(gname, function()
    for name, val in pairs(highlights) do
      local orig_val = vim.api.nvim_get_hl(0, { name = name, create = false })
      local merged_val = vim.tbl_extend("force", orig_val, val)
      vim.api.nvim_set_hl(0, name, merged_val)
    end
  end)
end

---@param gname string group_name
---@param highlights table<string, vim.api.keyset.highlight>
function M.force_set_highlights(gname, highlights)
  update_highlights(gname, function()
    for name, val in pairs(highlights) do
      vim.api.nvim_set_hl(0, name, val)
    end
  end)
end

return M
