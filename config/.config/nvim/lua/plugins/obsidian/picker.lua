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
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local sorters = require("telescope.sorters")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local make_entry = require("telescope.make_entry")

  local cmd = {
    "fd",
    "--type",
    "f",
    "--regex",
    [[(^[0-9]{12}.*\.(md|mdx)$)|(^[0-9]{4}-[0-9]{2}-[0-9]{2}\.(md|mdx)$)]],
    ".",
  }
  local vault = Obsidian.dir.filename
  local gen_file = make_entry.gen_from_file({ cwd = vault })

  local now = os.time()
  local cutoff = tostring(os.date("%Y%m%d%H%M", now - 7 * 24 * 60 * 60))

  local finder = finders.new_oneshot_job(cmd, {
    cwd = vault,
    entry_maker = function(line)
      local e = gen_file(line)
      if not e then
        return nil
      end
      local filename = vim.fn.fnamemodify(e.path, ":t")
      local ts = extract_timestamp_from_filename(filename)
      if not ts or ts < cutoff then
        return nil
      end
      return e
    end,
  })

  pickers
    .new({}, {
      prompt_title = "Recent Files",
      finder = finder,
      sorter = conf.file_sorter({}),
      previewer = conf.file_previewer({}),
      cwd = vault,
      attach_mappings = function(bufnr, _)
        actions.select_default:replace(function()
          actions.close(bufnr)
          local entry = action_state.get_selected_entry()
          if not entry then
            return
          end
          cb(entry.path)
        end)
        return true
      end,
    })
    :find()
end

return M
