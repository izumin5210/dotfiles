local M = {}

---@param gname string group_name
---@param f fun()
local function update_highlights(gname, f)
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

---@alias keymap_mode 'n' | 'v' | 'i'
---@alias keymap { [1]: keymap_mode | keymap_mode[], [2]: string, [3]: string | function, desc: string }

--- Build keymap table for lazy.nvim
---@param opt { [1]: keymap[], common?: { noremap?: boolean, silent?: boolean, expr?: boolean }, desc_prefix?: string }
---@return keymap[]
function M.lazy_keymap(opt)
  local res = {}
  local keymaps = opt[1]
  local desc_prefix = opt.desc_prefix == nil and "" or (opt.desc_prefix .. ": ")
  local common = opt.common == nil and {} or opt.common
  for _, km in pairs(keymaps) do
    local desc = km.desc == nil and "" or (desc_prefix .. km.desc)
    table.insert(res, vim.tbl_extend("keep", { km[2], km[3], mode = km[1], desc = desc }, common))
  end
  return res
end

return M
