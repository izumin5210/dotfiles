-----------------------------------
-- Editor
-----------------------------------
vim.opt.updatetime       = 2000

-- edit
vim.opt.encoding         = 'utf-8'
vim.opt.fileencoding     = 'utf-8'
vim.opt.wrap             = false

-- completion
vim.opt.completeopt      = 'menu,menuone,noselect'

-- show whitespace chars
vim.opt.list             = true
vim.opt.listchars        = 'tab:»-,trail:_,eol:↲,extends:»,precedes:«,nbsp:･'

-- search
vim.opt.ignorecase       = true
vim.opt.smartcase        = true
vim.opt.incsearch        = true
vim.opt.hlsearch         = true

-- clipboard
vim.opt.clipboard        = 'unnamedplus'

-- indent
vim.opt.autoindent       = true
vim.opt.smartindent      = true
vim.opt.expandtab        = true
vim.opt.tabstop          = 2
vim.opt.softtabstop      = 2
vim.opt.shiftwidth       = 2
vim.opt.shiftround       = true

-- split
vim.opt.splitbelow       = true
vim.opt.splitright       = true

-- disable netrw
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1

-- disable builtin statusline and tablne
vim.opt.laststatus       = 0
vim.opt.showtabline      = 0

-- disable builtin matchit.vim and matchparen.vim
vim.g.loaded_matchit     = 1
vim.g.loaded_matchparen  = 1

-- hide cmdline
vim.opt.cmdheight        = 0

-- sign
vim.opt.signcolumn       = 'yes';

-- lsp
vim.diagnostic.config({ virtual_text = false })

-----------------------------------
-- Keymaps
-----------------------------------
vim.g.mapleader = ' '
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>',
  { noremap = true, desc = 'Search: Clear Search Highlight' })

-- buffers
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { noremap = true, desc = 'Buffer: Next' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { noremap = true, desc = 'Buffer: Prev' })
vim.keymap.set('n', '<leader>bd', function() require('bufdelete').bufdelete(0, false) end,
  { noremap = true, desc = 'Buffer: Delete' })

-- tabs
vim.keymap.set('n', '<leader>btt', ':tabnew<CR>', { noremap = true, desc = 'Tab: New' })
vim.keymap.set('n', '<leader>btn', ':tabnext<CR>', { noremap = true, desc = 'Tab: Next' })
vim.keymap.set('n', '<leader>btp', ':tabprevious<CR>', { noremap = true, desc = 'Tab: Prev' })

-----------------------------------
-- Plugins
-----------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Libraries
  {
    'nvim-tree/nvim-web-devicons', -- required by lualine and nvim-tree.lua
    lazy = true,
    config = function()
      require('nvim-web-devicons').setup()
    end,
  },
  {
    'mortepau/codicons.nvim', -- required by config function for nvim-dap
    lazy = true,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
    tag = 'v0.1.3'
  },
  {
    'tpope/vim-repeat', -- required by leap.nvim
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  -- LSP
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      {
        'williamboman/mason.nvim',
        config = require('pluginconfig.lspconfig').setup_mason,
      },
      {
        'jose-elias-alvarez/null-ls.nvim',
        config = require('pluginconfig.lspconfig').setup_null_ls,
      },
      {
        'jayp0521/mason-null-ls.nvim',
        config = require('pluginconfig.lspconfig').setup_mason_null_ls,
      },
      {
        'ray-x/lsp_signature.nvim',
        init = require('pluginconfig.lspconfig').init_lsp_signature,
        config = require('pluginconfig.lspconfig').setup_lsp_signature,
      },
      {
        'nvimdev/lspsaga.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        event = { 'LspAttach' },
        config = require('pluginconfig.lspconfig').setup_lspsaga,
      },
    },
    init = require('pluginconfig.lspconfig').init,
    config = require('pluginconfig.lspconfig').setup,
  },
  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-cmdline',
      {
        'zbirenbaum/copilot-cmp',
        dependencies = { 'zbirenbaum/copilot.lua' },
        config = require('pluginconfig.cmp').setup_copilot_cmp,
      },
      {
        'onsails/lspkind.nvim',
        config = require('pluginconfig.cmp').setup_lspkind,
      },
    },
    keys = require('pluginconfig.cmp').keys,
    init = require('pluginconfig.cmp').init,
    config = require('pluginconfig.cmp').setup,
  },
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'CursorHold', 'CursorHoldI' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = require('pluginconfig.treesitter').setup_treesitter_context,
      },
      'nvim-treesitter/nvim-treesitter-textobjects', -- required by nvim-surround
      'JoosepAlviste/nvim-ts-context-commentstring',
      {
        'HiPhish/nvim-ts-rainbow2',
        init = require('pluginconfig.treesitter').init_ts_rainbow2,
      },
      {
        'haringsrob/nvim_context_vt',
        init = require('pluginconfig.treesitter').init_context_vt,
        config = require('pluginconfig.treesitter').setup_context_vt,
      },
      'andymass/vim-matchup',
      'windwp/nvim-ts-autotag',
    },
    config = require('pluginconfig.treesitter').setup,
  },
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'otavioschwanck/telescope-alternate.nvim',
      'stevearc/aerial.nvim',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    cmd = 'Telescope',
    keys = require('pluginconfig.telescope').keys,
    config = require('pluginconfig.telescope').setup,
  },
  -- Debugger
  {
    'mfussenegger/nvim-dap',
    cond = not vim.g.vscode,
    dependencies = {
      {
        'leoluz/nvim-dap-go',
        ft = 'go',
        config = require('pluginconfig.dap').setup_go,
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        config = require('pluginconfig.dap').setup_dap_virtual_text,
      }
    },
    keys = require('pluginconfig.dap').keys,
    config = require('pluginconfig.dap').setup,
  },
  -- Runner
  {
    'klen/nvim-test',
    keys = require('pluginconfig.test').keys,
    config = require('pluginconfig.test').setup,
  },
  -- Appearance
  { 'cocopon/iceberg.vim', cond = not vim.g.vscode },
  {
    'nvim-lualine/lualine.nvim',
    event = { 'InsertEnter', 'CursorHold', 'FocusLost', 'BufRead', 'BufNewFile' },
    cond = not vim.g.vscode,
    dependencies = { 'arkav/lualine-lsp-progress' },
    config = require('pluginconfig.lualine').setup,
  },
  {
    'akinsho/bufferline.nvim',
    cond = not vim.g.vscode,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('pluginconfig.bufferline').setup,
  },
  {
    'stevearc/aerial.nvim',
    lazy = true,
    config = function()
      require('aerial').setup()
    end,
  },
  {
    'petertriho/nvim-scrollbar',
    cond = not vim.g.vscode,
    event = 'BufReadPost',
    config = function()
      require('scrollbar').setup({
        marks = {
          Search = { color_nr = '3', color = '#c57339' },
          Error = { color_nr = '9', color = '#cc3768' },
          Warn = { color_nr = '11', color = '#b6662d' },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
        }
      })
    end
  },
  {
    'kevinhwang91/nvim-hlslens',
    cond = not vim.g.vscode,
    event = 'BufReadPost',
    init = function()
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight link HlSearchLens DiagnosticHint',
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight link HlSearchLensNear DiagnosticHint',
      })
    end,
    config = function()
      require('scrollbar.handlers.search').setup({})
    end
  },
  {
    'lewis6991/gitsigns.nvim',
    cond = not vim.g.vscode,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    init = function()
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight SignColumn ctermbg=none guibg=none'
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight GitGutterAdd ctermbg=none guibg=none'
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight GitGutterChange ctermbg=none guibg=none'
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight GitGutterDelete ctermbg=none guibg=none'
      })
    end,
    config = function()
      require('gitsigns').setup()
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },
  {
    'folke/which-key.nvim',
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    config = require('pluginconfig.which-key').setup,
  },
  {
    'mvllow/modes.nvim',
    tag = 'v0.2.0',
    event = { 'CursorMoved', 'CursorMovedI' },
    config = require('pluginconfig.modes').setup,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    cond = not vim.g.vscode,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('indent_blankline').setup({
        space_char_blankline = ' ',
        show_current_context = true,
        -- show_current_context_start = true,
      })
    end
  },
  {
    'zbirenbaum/neodim',
    cond = not vim.g.vscode,
    event = 'LspAttach',
    config = function()
      require('neodim').setup()
    end
  },
  -- Editor
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup()
    end,
  },
  {
    'ggandor/flit.nvim',
    dependencies = {
      { 'ggandor/leap.nvim', lazy = true },
    },
    keys = {
      { 'f', mode = { 'n' } },
      { 'F', mode = { 'n' } },
      { 't', mode = { 'n' } },
      { 'T', mode = { 'n' } },
    },
    config = function()
      require('flit').setup()
    end
  },
  {
    'numToStr/Comment.nvim',
    keys = { { '<Leader>/', mode = { 'n', 'v' } } },
    config = function()
      require('Comment').setup({
        toggler = {
          line = '<Leader>/',
        },
        opleader = {
          line = '<Leader>/',
        },
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },
  {
    'danymat/neogen',
    keys = { { '<Leader>cd', function() require('neogen').generate() end, mode = 'n', desc = 'Generate doc comment' } },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('neogen').setup({
        snippet_engine = 'vsnip',
      })
    end,
  },
  {
    'kylechui/nvim-surround',
    event = { 'CursorHold', 'CursorHoldI' },
    config = function()
      require('nvim-surround').setup()
    end,
  },
  {
    'folke/todo-comments.nvim',
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim', },
    config = function()
      require('todo-comments').setup({
        highlight = { after = '' }
      })
    end,
  },
  {
    'RRethy/vim-illuminate',
    cond = not vim.g.vscode,
    event = { 'CursorMoved', 'CursorMovedI' },
    init = function()
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight IlluminatedWordText ctermbg=238 guibg=#33374c'
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight IlluminatedWordRead ctermbg=238 guibg=#33374c'
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight IlluminatedWordWrite ctermbg=238 guibg=#33374c'
      })
    end,
    config = function()
      require('illuminate').configure()
    end,
  },
  {
    'ntpeters/vim-better-whitespace',
    cond = not vim.g.vscode,
    event = 'VeryLazy',
    init = function()
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight ExtraWhitespace guibg=#e27878'
      })
    end,
    config = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_whitespace_confirm = 0
    end
  },
  {
    'dinhhuy258/git.nvim',
    keys = {
      { '<Leader>go', desc = 'Git: Open in GitHub' },
      { '<Leader>gp', desc = 'Git: Open Pull Request Page' },
    },
    config = function()
      require('git').setup()
    end
  },
  {
    'monaqa/dial.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = require('pluginconfig.dial').keys,
    config = require('pluginconfig.dial').setup,
  },
  {
    'famiu/bufdelete.nvim',
    lazy = true,
  },
  {
    'rapan931/lasterisk.nvim',
    keys = {
      {
        '*',
        function()
          require('lasterisk').search()
          require('hlslens').start()
        end,
        mode = 'n'
      },
      {
        'g*',
        function()
          require('lasterisk').search({ is_whole = false })
          require('hlslens').start()
        end,
        mode = { 'n', 'x' }
      },
    },
  },
  -- lang
  {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    ft = 'json',
    cond = not vim.g.vscode,
    init = function()
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight link PackageInfoOutdatedVersion DiagnosticHint'
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = 'highlight link PackageInfoUpToDateVersion DiagnosticHint'
      })
    end,
    config = function()
      require('package-info').setup({
        autostart = true,
        hide_up_to_date = true,
        hide_unstable_version = true,
      })
      require('package-info').show()
    end
  },
  { 'jxnblk/vim-mdx-js' },
  -- misc
  {
    'rmagatti/auto-session',
    cond = not vim.g.vscode,
    config = function()
      vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
      require('auto-session').setup({
        session_lens = {
          load_on_setup = false,
        }
      })
    end,
  },
  {
    'alexghergh/nvim-tmux-navigation',
    cond = not vim.g.vscode,
    keys = {
      { '<C-w>h', function() require('nvim-tmux-navigation').NvimTmuxNavigateLeft() end,  mode = 'n', noremap = true },
      { '<C-w>j', function() require('nvim-tmux-navigation').NvimTmuxNavigateDown() end,  mode = 'n', noremap = true },
      { '<C-w>k', function() require('nvim-tmux-navigation').NvimTmuxNavigateUp() end,    mode = 'n', noremap = true },
      { '<C-w>l', function() require('nvim-tmux-navigation').NvimTmuxNavigateRight() end, mode = 'n', noremap = true },
      {
        '<C-w>\\',
        function() require('nvim-tmux-navigation').NvimTmuxNavigateLastActive() end,
        mode = 'n',
        noremap = true
      },
      { '<C-w>Space', function() require('nvim-tmux-navigation').NvimTmuxNavigateNext() end, mode = 'n', noremap = true },
    },
    config = function()
      require('nvim-tmux-navigation').setup({ disable_when_zoomed = true })
    end,
  },
})

-----------------------------------
-- Appearance
-----------------------------------
vim.api.nvim_create_autocmd('Colorscheme', {
  pattern = '*',
  command = 'highlight! link DiagnosticHint LineNr'
})

if not vim.g.vscode then
  -- clear bg
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight Normal ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight NonText ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight LineNr ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight Folded ctermbg=none guibg=none'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight EndOfBuffer ctermbg=none guibg=none'
  })
  -- floating
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight NormalFloat guibg=#1e2132'
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight FloatBorder guibg=#1e2132 blend=20'
  })
  vim.opt.termguicolors = true
  vim.opt.winblend = 20
  vim.opt.pumblend = 20
  vim.cmd.colorscheme('iceberg')
end
