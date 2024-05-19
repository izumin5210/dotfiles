local M = {}

local actions = {
  suite = function()
    require("nvim-test").run("suite")
  end,
  file = function()
    require("nvim-test").run("file")
  end,
  nearest = function()
    require("nvim-test").run("nearest")
  end,
  visit = function()
    require("nvim-test").visit()
  end,
}

M.keys = require("utils").lazy_keymap({
  {
    { "n", "<leader>ts", actions.suite, desc = "Run Suite" },
    { "n", "<leader>tf", actions.file, desc = "Run File" },
    { "n", "<leader>tn", actions.nearest, desc = "Run Nearest" },
    { "n", "<leader>tv", actions.visit, desc = "Visit the last run test" },
  },
  desc_prefix = "Test",
})

function M.setup()
  require("nvim-test").setup({
    termOpts = {
      direction = "float",
    },
  })
  require("nvim-test.runners.go-test"):setup({
    command = "gotest",
    args = { "-v" },
  })
end

return M
