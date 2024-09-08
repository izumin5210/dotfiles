local M = {}

M.actions = {
  find_files = function()
    require("telescope.builtin").find_files()
  end,
  grep = function()
    require("telescope.builtin").live_grep()
  end,
  git_status = function()
    require("telescope.builtin").git_status()
  end,
  conflicted_files = function()
    require("telescope.builtin").git_files({
      git_command = { "git", "diff", "--name-only", "--diff-filter=U" },
    })
  end,
  buffers = function()
    require("telescope.builtin").buffers()
  end,
  alternate_files = function()
    require("telescope").extensions["telescope-alternate"].alternate_file()
  end,
  aerial = function()
    require("telescope").extensions["aerial"].aerial({ filter_kind = { "Function", "Method" } })
  end,
}

function M.init()
  local palette = require("rc.colors").palette

  require("rc.utils").set_highlights("teelscope_hl", {
    TelescopeNormal = { bg = palette.mantle },
    TelescopeTitle = { bg = palette.mantle },
    TelescopePromptNormal = { bg = palette.crust },
    TelescopePromptBorder = { bg = palette.crust },
    TelescopePromptTitle = { bg = palette.crust },
  })

  require("rc.utils").force_set_highlights("telescope_hl_force", {
    TelescopeBorder = { bg = palette.mantle },
    TelescopePromptTitle = { bg = palette.crust, fg = palette.overlay0 },
    TelescopeTitle = { bg = palette.mantle, fg = palette.overlay0 },
    TelescopePromptPrefix = { fg = palette.sky },
  })
end

function M.setup()
  local telescope = require("telescope")

  telescope.setup({
    defaults = {
      prompt_prefix = "   ",
      selection_caret = "   ",
      entry_prefix = "    ",
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        prompt_position = "top",
      },
      mappings = {
        i = {
          ["<esc>"] = require("telescope.actions").close,
          ["<C-u>"] = false,
        },
      },
      -- create padding around the floating window
      borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
      path_display = { "truncate" },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      ["telescope-alternate"] = {
        mappings = {
          -- go
          { "(.*).go", {
            { "[1]_test.go", "Test", false },
          } },
          { "(.*)_test.go", {
            { "[1].go", "Source", false },
          } },
          -- js, ts
          {
            "(.*)/([^!]*).([cm]?[tj]s)(x?)",
            {
              { "[1]/[2].test.[3][4]", "Test", false },
              { "[1]/[2].spec.[3][4]", "Test", false },
              { "[1]/[2].stories.[3][4]", "Storybook", false },
              { "[1]/[2].test.[3]", "Test", false },
              { "[1]/[2].spec.[3]", "Test", false },
              { "[1]/[2].stories.[3]", "Storybook", false },
              { "[1]/index.[3]", "Index", false },
            },
          },
          {
            "(.*)/([^!]*).(?:(test|spec)).([cm]?[tj]s)(x?)",
            {
              { "[1]/[2].[3][4]", "Source", false },
              { "[1]/[2].stories.[3][4]", "Source Storybook", false },
              { "[1]/[2].[3]", "Source", false },
              { "[1]/[2].stories.[3]", "Source Storybook", false },
            },
          },
          {
            "(.*)/([^!]*).stories.([cm]?[tj]s)(x?)",
            {
              { "[1]/[2].[3][4]", "Source", false },
              { "[1]/[2].test.[3][4]", "Source Test", false },
              { "[1]/[2].spec.[3][4]", "Source Test", false },
              { "[1]/[2].[3]", "Source", false },
              { "[1]/[2].test.[3]", "Source Test", false },
              { "[1]/[2].spec.[3]", "Source Test", false },
            },
          },
        },
      },
    },
  })
  telescope.load_extension("fzf")
  telescope.load_extension("telescope-alternate")
  telescope.load_extension("aerial")
  telescope.load_extension("dap")
end

return M
