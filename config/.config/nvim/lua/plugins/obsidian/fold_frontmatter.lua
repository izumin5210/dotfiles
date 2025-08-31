local M = {}

---find frontmatter range using treesitter
---@param buf number
---@return {sr: number}|nil
local function fm_range(buf)
  local ok, parser = pcall(vim.treesitter.get_parser, buf, "markdown")
  if not ok or not parser then
    return nil
  end
  local tree = parser:parse()[1]
  if not tree then
    return nil
  end
  local root = tree:root()
  local query = vim.treesitter.query.parse(
    "markdown",
    [[
    (minus_metadata) @fm
    (plus_metadata)  @fm
  ]]
  )

  for id, node, _ in query:iter_captures(root, buf, 0, -1) do
    if query.captures[id] == "fm" then
      local sr = select(1, node:range())
      return { sr = sr }
    end
  end
  return nil
end

---@param buf number
local function fold_frontmatter(buf)
  local utils = require("plugins.obsidian.utils")
  if not utils.is_md(buf) then
    return
  end

  local rng = fm_range(buf)
  if not rng then
    return
  end

  -- カーソル退避
  local win = vim.fn.bufwinid(buf)
  if win == -1 then
    return
  end
  local cur = vim.api.nvim_win_get_cursor(win)

  -- frontmatter 行に一瞬だけ移動して zc、カーソル復帰
  vim.api.nvim_win_set_cursor(win, { rng.sr + 1, 0 })
  vim.cmd("silent! normal! zc")
  vim.api.nvim_win_set_cursor(win, cur)
end

return fold_frontmatter
