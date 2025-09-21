local M = {}

---@param filename string
---@return string?|nil prefix
local function extract_timestamp_from_filename(filename)
  -- YYYYMMDDHHMM prefix
  local p12 = filename:match("^(%d%d%d%d%d%d%d%d%d%d%d%d)")
  if p12 then
    return p12
  end
  -- YYYY-MM-DD.md -> YYYYMMDD0000
  local y, m, d = filename:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)%.%w+$")
  if y and m and d then
    return (y .. m .. d .. "0000")
  end
  return nil
end

---@param cb fun(path: string)
function M.list_recent_files(cb)
  local now = os.time()
  local cutoff = tostring(os.date("%Y%m%d%H%M", now - 7 * 24 * 60 * 60))

  Snacks.picker.files({
    cmd = "fd",
    args = {
      "--type",
      "f",
      "--regex",
      [[(^[0-9]{12}.*\.(md|mdx)$)|(^[0-9]{4}-[0-9]{2}-[0-9]{2}\.(md|mdx)$)]],
      ".",
    },
    cwd = Obsidian.dir.filename,
    matcher = {
      frecency = true,
      history_bonus = true,
    },
    transform = function(item)
      local filename = vim.fn.fnamemodify(item.file, ":t")
      local ts = extract_timestamp_from_filename(filename)
      return ts and ts > cutoff
    end,
  })
end

return M
