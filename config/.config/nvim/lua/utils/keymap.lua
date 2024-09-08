local M = {}

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
