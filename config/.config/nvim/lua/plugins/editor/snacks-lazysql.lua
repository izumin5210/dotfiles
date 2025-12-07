local MYSQL_URL = "mysql://root:password@127.0.0.1:3306"
local POSTGRES_URL = "postgres://postgres:password@localhost:5432?sslmode=disable"

---@class DatabaseItem
---@field text string
---@field db_type "mysql"|"postgres"
---@field db_name string

---@param on_done fun(items: DatabaseItem[])
local function list_databases(on_done)
  local items = {} ---@type DatabaseItem[]
  local pending = 2

  local function check_done()
    pending = pending - 1
    if pending == 0 then
      on_done(items)
    end
  end

  -- MySQL
  vim.system(
    { "mysql", "-u", "root", "-ppassword", "-h", "127.0.0.1", "-P", "3306", "-N", "-e", "SHOW DATABASES;" },
    { text = true, timeout = 1000 },
    function(result)
      if result.code == 0 and result.stdout then
        for db in result.stdout:gmatch("[^\r\n]+") do
          table.insert(items, {
            text = string.format("%-10s%s", "mysql", db),
            db_type = "mysql",
            db_name = db,
          })
        end
      end
      check_done()
    end
  )

  -- PostgreSQL
  vim.system(
    { "psql", POSTGRES_URL, "-t", "-c", "SELECT datname FROM pg_database WHERE datistemplate = false;" },
    { text = true, timeout = 1000 },
    function(result)
      if result.code == 0 and result.stdout then
        for db in result.stdout:gmatch("[^\r\n]+") do
          db = vim.trim(db)
          if db ~= "" then
            table.insert(items, {
              text = string.format("%-10s%s", "postgres", db),
              db_type = "postgres",
              db_name = db,
            })
          end
        end
      end
      check_done()
    end
  )
end

---@param item DatabaseItem
---@return string
local function build_url(item)
  if item.db_type == "mysql" then
    return MYSQL_URL .. "/" .. item.db_name
  elseif item.db_type == "postgres" then
    local base = POSTGRES_URL:gsub("%?.*$", "")
    return base .. "/" .. item.db_name .. "?sslmode=disable"
  end
  error("Unknown database type: " .. item.db_type)
end

local function open_lazysql_picker()
  list_databases(function(items)
    vim.schedule(function()
      require("snacks").picker.pick({
        title = "Databases",
        items = items,
        format = "text",
        layout = { preset = "select" },
        confirm = function(picker, item)
          picker:close()
          if item then
            local url = build_url(item)
            vim.schedule(function()
              require("snacks").terminal({ "lazysql", url }, {
                win = {
                  position = "float",
                  width = 0.9,
                  height = 0.9,
                  border = { " ", " ", " ", " ", " ", " ", " ", " " },
                },
              })
            end)
          end
        end,
      })
    end)
  end)
end

return {
  "snacks.nvim",
  ---@type snacks.Config
  opts = {
    terminal = { enable = true },
  },
  keys = {
    {
      "<leader>ld",
      mode = "n",
      noremap = true,
      desc = "Database: Open lazysql",
      open_lazysql_picker,
    },
  },
}
