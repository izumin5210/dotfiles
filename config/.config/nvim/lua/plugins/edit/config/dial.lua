local M = {}

local switch_groups = {
  go = "switch_go",
  javascript = "switch_js",
  javascriptreact = "switch_js",
  typescript = "switch_js",
  typescriptreact = "switch_js",
}

local function get_switch_group()
  return switch_groups[vim.bo.filetype] or "switch"
end

local actions = {
  inc_normal = function()
    return require("dial.map").inc_normal()
  end,
  dec_normal = function()
    return require("dial.map").dec_normal()
  end,
  inc_visual = function()
    return require("dial.map").inc_visual()
  end,
  dec_visual = function()
    return require("dial.map").dec_visual()
  end,
  inc_gvisual = function()
    return require("dial.map").inc_gvisual()
  end,
  dec_gvisual = function()
    return require("dial.map").dec_gvisual()
  end,
  inc_custom = function()
    return require("dial.map").inc_normal(get_switch_group())
  end,
  dec_custom = function()
    return require("dial.map").dec_normal(get_switch_group())
  end,
}

M.keys = require("rc.utils").lazy_keymap({
  {
    { "n", "<C-a>", actions.inc_normal, desc = "Increment" },
    { "n", "<C-x>", actions.dec_normal, desc = "Decrement" },
    { "v", "<C-a>", actions.inc_visual, desc = "Increment" },
    { "v", "<C-x>", actions.dec_visual, desc = "Decrement" },
    { "v", "g<C-a>", actions.inc_gvisual, desc = "Increment" },
    { "v", "g<C-x>", actions.dec_gvisual, desc = "Decrement" },
    { "n", "<leader>a", actions.inc_custom, desc = "Switch prev" },
    { "n", "<leader>x", actions.dec_custom, desc = "Switch next" },
  },
  desc_prefix = "Edit",
  common = { expr = true, noremap = true },
})

function M.setup()
  local augend = require("dial.augend")
  local switch_common = {
    augend.constant.alias.bool,
    augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
    augend.constant.new({ elements = { "==", "!=" }, word = false, cyclic = true }),
    augend.case.new({
      types = { "camelCase", "snake_case", "kebab-case" },
      cyclic = true,
    }),
    augend.case.new({
      types = { "PascalCase", "SCREAMING_SNAKE_CASE" },
      cyclic = true,
    }),
  }
  require("dial.config").augends:register_group({
    switch = switch_common,
    switch_go = vim.list_extend({
      augend.constant.new({ elements = { "=", ":=" }, word = false, cyclic = true }),
      augend.constant.new({ elements = { "var", "const" }, cyclic = true }),
    }, switch_common),
    switch_js = vim.list_extend({
      augend.constant.new({ elements = { "let", "const" }, cyclic = true }),
    }, switch_common),
  })
end

return M
