local M = {}

local actions = {
  find_files = function()
    require('telescope.builtin').find_files()
  end,
  grep = function()
    require('telescope.builtin').live_grep()
  end,
  git_status = function()
    require('telescope.builtin').git_status()
  end,
  conflicted_files = function()
    require('telescope.builtin').git_files({
      git_command = { 'git', 'diff', '--name-only', '--diff-filter=U' },
    })
  end,
  buffers = function()
    require('telescope.builtin').buffers()
  end,
  alternate_files = function()
    require('telescope').extensions['telescope-alternate'].alternate_file()
  end,
  aerial = function()
    require('telescope').extensions['aerial'].aerial({ filter_kind = { 'Function', 'Method' } })
  end,
}

M.keys = require('utils').lazy_keymap({
  {
    { 'n', '<leader><leader>', actions.find_files, desc = 'File: Go to ...' },
    { 'n', '<leader>gg', actions.grep, desc = 'File: Grep' },
    { 'n', '<leader>gs', actions.git_status, desc = 'File: Git Suatus' },
    { 'n', '<leader>gu', actions.conflicted_files, desc = 'File: Git Unmerged Files' },
    { 'n', '<leader>gb', actions.buffers, desc = 'File: Buffers' },
    { 'n', '<leader>ga', actions.alternate_files, desc = 'File: Alternate' },
    { 'n', '<leader>gf', actions.aerial, desc = 'LSP: Functions and Methods' },
  },
  common = { noremap = true },
})

function M.setup()
  local telescope = require('telescope')

  telescope.setup({
    defaults = {
      layout_strategy = 'vertical',
      layout_config = {},
      mappings = {
        i = {
          ['<esc>'] = require('telescope.actions').close,
          ['<C-u>'] = false,
        },
      },
      winblend = 20,
    },
    extensions = {
      ['telescope-alternate'] = {
        mappings = {
          -- go
          { '(.*).go', {
            { '[1]_test.go', 'Test', false },
          } },
          { '(.*)_test.go', {
            { '[1].go', 'Source', false },
          } },
          -- js, ts
          {
            '(.*)/([^!]*).([cm]?[tj]s)(x?)',
            {
              { '[1]/[2].test.[3][4]', 'Test', false },
              { '[1]/[2].spec.[3][4]', 'Test', false },
              { '[1]/[2].stories.[3][4]', 'Storybook', false },
              { '[1]/[2].test.[3]', 'Test', false },
              { '[1]/[2].spec.[3]', 'Test', false },
              { '[1]/[2].stories.[3]', 'Storybook', false },
              { '[1]/index.[3]', 'Index', false },
            },
          },
          {
            '(.*)/([^!]*).(?:(test|spec)).([cm]?[tj]s)(x?)',
            {
              { '[1]/[2].[3][4]', 'Source', false },
              { '[1]/[2].stories.[3][4]', 'Source Storybook', false },
              { '[1]/[2].[3]', 'Source', false },
              { '[1]/[2].stories.[3]', 'Source Storybook', false },
            },
          },
          {
            '(.*)/([^!]*).stories.([cm]?[tj]s)(x?)',
            {
              { '[1]/[2].[3][4]', 'Source', false },
              { '[1]/[2].test.[3][4]', 'Source Test', false },
              { '[1]/[2].spec.[3][4]', 'Source Test', false },
              { '[1]/[2].[3]', 'Source', false },
              { '[1]/[2].test.[3]', 'Source Test', false },
              { '[1]/[2].spec.[3]', 'Source Test', false },
            },
          },
        },
      },
    },
  })
  telescope.load_extension('telescope-alternate')
  telescope.load_extension('aerial')
  telescope.load_extension('dap')
end

return M
