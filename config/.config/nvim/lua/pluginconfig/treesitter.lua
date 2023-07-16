local M = {}

function M.setup_treesitter_context()
  require('treesitter-context').setup()
end

function M.init_ts_rainbow2()
  local augroup = vim.api.nvim_create_augroup('ts_rainbow2_init', { clear = true })

  vim.api.nvim_create_autocmd('Colorscheme', {
    group = augroup,
    pattern = '*',
    command = 'highlight link TSRainbowRed DiagnosticError'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    group = augroup,
    pattern = '*',
    command = 'highlight link TSRainbowYellow DiagnosticWarn'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    group = augroup,
    pattern = '*',
    command = 'highlight TSRainbowGreen guifg=#b4be82'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    group = augroup,
    pattern = '*',
    command = 'highlight TSRainbowBlue guifg=#84a0c6'
  })
end

function M.setup_context_vt()
  require('nvim_context_vt').setup({
    min_rows = 3,
  })
end

function M.init_context_vt()
  local augroup = vim.api.nvim_create_augroup('context_vt_init', { clear = true })

  vim.api.nvim_create_autocmd('Colorscheme', {
    group = augroup,
    pattern = '*',
    command = 'highlight link ContextVt DiagnosticHint'
  })
end

function M.setup()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'bash',
      'css',
      'cue',
      -- 'diff',
      'dockerfile',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'go',
      'gomod',
      'gosum',
      'gowork',
      'graphql',
      'hcl',
      'html',
      'javascript',
      'jq',
      'jsdoc',
      'json',
      'json5',
      'jsonnet',
      'lua',
      'make',
      'markdown',
      'markdown_inline', -- required by lspsaga.nvim
      'proto',
      'python',
      'regex',
      'ruby',
      'rust',
      'scss',
      'sql',
      'starlark',
      'toml',
      'tsx',
      'typescript',
      'vim',
      'vue',
      'yaml',
    },
    -- indent = {
    --   enable = true,
    -- },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 1500,
      query = {
        'rainbow-parens',
        html = 'rainbow-tags',
        javascript = 'rainbow-tags-react',
        tsx = 'rainbow-tags',
        vue = 'rainbow-tags',
      },
      strategy = require('ts-rainbow').strategy.global,
      hlgroups = {
        'TSRainbowRed',
        'TSRainbowYellow',
        'TSRainbowGreen',
        'TSRainbowBlue',
      }
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    matchup = {
      enable = true,
    },
    autotag = {
      enable = true,
    }
  })
end

return M
