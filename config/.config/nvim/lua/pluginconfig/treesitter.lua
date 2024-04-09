local M = {}

function M.setup_treesitter_context()
  require('treesitter-context').setup({
    max_lines = 4,
  })
end

function M.init_rainbow_delimiters()
  local rainbow_delimiters = require('rainbow-delimiters')
  vim.g.rainbow_delimiters = {
    strategy = {
      [''] = rainbow_delimiters.strategy['global'],
      vim = rainbow_delimiters.strategy['local'],
    },
    query = {
      [''] = 'rainbow-delimiters',
      lua = 'rainbow-blocks',
    },
  }
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
    context_commentstring = {
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
