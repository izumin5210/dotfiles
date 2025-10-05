return {
  "monaqa/dial.nvim",
  vscode = true,
  dependencies = { "plenary.nvim" },
  keys = function()
    ---@param dir "inc"|"dec"
    ---@param g ''|'g'
    local manipulate_func = function(dir, g)
      return function()
        local m = vim.fn.mode(true)
        local is_visual = m == "v" or m == "V" or m == "\22"
        local mode = g .. (is_visual and "visual" or "normal")
        local group_name = require("dial.config").augends.group[vim.bo.filetype] and vim.bo.filetype or "default"
        return require("dial.map").manipulate(dir .. "rement", mode, group_name)
      end
    end

    return {
      { "<C-a>", manipulate_func("inc", ""), mode = { "n", "x" }, desc = "Edit: Increment" },
      { "<C-x>", manipulate_func("dec", ""), mode = { "n", "x" }, desc = "Edit: Decrement" },
      { "g<C-a>", manipulate_func("inc", "g"), mode = { "n", "x" }, desc = "Edit: Increment" },
      { "g<C-x>", manipulate_func("inc", "g"), mode = { "n", "x" }, desc = "Edit: Decrement" },
    }
  end,
  config = function()
    local augend = require("dial.augend")

    local weekdays = augend.constant.new({
      elements = {
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      },
      word = true,
      cyclic = true,
    })

    local months = augend.constant.new({
      elements = {
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      },
      word = true,
      cyclic = true,
    })

    local default = {
      augend.integer.alias.decimal,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
      augend.date.alias["%Y-%m-%d"],
      augend.constant.alias.ja_weekday_full,
      weekdays,
      months,
      augend.constant.alias.bool,
      augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
      augend.constant.new({ elements = { "==", "!=" }, word = false, cyclic = true }),
      augend.case.new({ types = { "camelCase", "snake_case" }, cyclic = true }),
      augend.case.new({ types = { "PascalCase", "SCREAMING_SNAKE_CASE" }, cyclic = true }),
    }

    local group_go = vim.list_extend({
      augend.constant.new({ elements = { "=", ":=" }, word = false, cyclic = true }),
      augend.constant.new({ elements = { "var", "const" }, cyclic = true }),
    }, default)

    local group_js = vim.list_extend({
      augend.paren.new({
        patterns = { { '"', '"' }, { "'", "'" }, { "`", "`" } },
        nested = false,
        escape_char = [[\]],
        cyclic = true,
      }),
      augend.constant.new({ elements = { "let", "const" }, cyclic = true }),
    }, default)

    require("dial.config").augends:register_group({
      default = default,
      go = group_go,
      javascript = group_js,
      javascriptreact = group_js,
      typescript = group_js,
      typescriptreact = group_js,
    })
  end,
}
