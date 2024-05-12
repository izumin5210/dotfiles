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
vim.opt.listchars        = 'tab:│─,trail:_,extends:»,precedes:«,nbsp:･'

-- search
vim.opt.ignorecase       = true
vim.opt.smartcase        = true
vim.opt.incsearch        = true
vim.opt.hlsearch         = true

-- clipboard
if vim.fn.has('unnamedplus') == 1 then
  vim.opt.clipboard = 'unnamed,unnamedplus'
else
  vim.opt.clipboard = 'unnamed'
end

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

-- disable builtin tablne
vim.opt.showtabline      = 0

-- global statusline
vim.opt.laststatus       = 3

-- disable builtin matchit.vim and matchparen.vim
vim.g.loaded_matchit     = 1
vim.g.loaded_matchparen  = 1

-- hide cmdline
vim.opt.cmdheight        = 0

-- sign
vim.opt.signcolumn       = 'yes'

-- lsp
vim.diagnostic.config({ virtual_text = false })

-----------------------------------
-- Keymaps
-----------------------------------
vim.g.mapleader = ' '
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>',
  { noremap = true, desc = 'Search: Clear Search Highlight' })

-- buffers
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { noremap = true, desc = 'Buffer: Prev' })
vim.keymap.set('n', '<S-l>', ':bnext<CR>',     { noremap = true, desc = 'Buffer: Next' })
vim.keymap.set('n', '[b',    ':bprevious<CR>', { noremap = true, desc = 'Buffer: Prev' })
vim.keymap.set('n', ']b',    ':bnext<CR>',     { noremap = true, desc = 'Buffer: Next' })
-- <C-q> to delete buffer using bufdelete.nvim

if vim.g.vscode then
  vim.keymap.set('n', 'gi',
    function() require('vscode-neovim').call('editor.action.goToImplementation') end,
    { noremap = true, desc = 'Go to implementation' })
  vim.keymap.set('n', '[d',
    function() require('vscode-neovim').call('editor.action.marker.prev') end,
    { noremap = true, desc = 'Go to prev Diagnostic' })
  vim.keymap.set('n', ']d',
    function() require('vscode-neovim').call('editor.action.marker.next') end,
    { noremap = true, desc = 'Go to next Diagnostic' })
  vim.keymap.set('n', '<leader>rn',
    function() require('vscode-neovim').call('editor.action.rename') end,
    { noremap = true, desc = 'Rename Symbol' })
  vim.keymap.set('n', '<leader>q',
    function() require('vscode-neovim').call('workbench.actions.view.problems') end,
    { noremap = true, desc = 'Show Diagnostics list' })
end

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
    cond = not vim.g.vscode,
    lazy = true,
    config = function()
      require('nvim-web-devicons').setup()
    end,
  },
  {
    'mortepau/codicons.nvim', -- required by config function for nvim-dap
    cond = not vim.g.vscode,
    lazy = true,
  },
  {
    'nvim-lua/plenary.nvim',
    cond = not vim.g.vscode,
    lazy = true,
    version = '*'
  },
  {
    'tpope/vim-repeat', -- required by leap.nvim
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
  },
  -- LSP
  {
    'neovim/nvim-lspconfig',
    cond = not vim.g.vscode,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        version = "*",
      },
      {
        'williamboman/mason.nvim',
        version = "*",
        config = require('pluginconfig.lspconfig').setup_mason,
      },
      {
        'nvimtools/none-ls.nvim',
        config = require('pluginconfig.lspconfig').setup_null_ls,
      },
      {
        'jayp0521/mason-null-ls.nvim',
        version = "*",
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
    cond = not vim.g.vscode,
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
    version = '*',
    cond = not vim.g.vscode,
    event = { 'CursorHold', 'CursorHoldI' },
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        init = require('pluginconfig.treesitter').init_treesitter_context,
        config = require('pluginconfig.treesitter').setup_treesitter_context,
      },
      'nvim-treesitter/nvim-treesitter-textobjects', -- required by nvim-surround
      'JoosepAlviste/nvim-ts-context-commentstring',
      {
        'haringsrob/nvim_context_vt',
        init = require('pluginconfig.treesitter').init_context_vt,
        config = require('pluginconfig.treesitter').setup_context_vt,
      },
      {
        'andymass/vim-matchup',
        version = '*',
      },
      'windwp/nvim-ts-autotag',
    },
    config = require('pluginconfig.treesitter').setup,
  },
  -- Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    cond = not vim.g.vscode,
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'otavioschwanck/telescope-alternate.nvim',
      'stevearc/aerial.nvim',
      'nvim-telescope/telescope-dap.nvim',
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
    cond = not vim.g.vscode,
    keys = require('pluginconfig.test').keys,
    config = require('pluginconfig.test').setup,
  },
  -- Appearance
  {
    "catppuccin/nvim",
    name = "catppuccin",
    cond = not vim.g.vscode,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = 'frappe',
        transparent_background = true,
        integrations = {
          aerial = true,
          fidget = true,
          lsp_saga = true,
          mason = true,
          which_key = true,
        },
      })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    cond = not vim.g.vscode,
    event = { 'InsertEnter', 'CursorHold', 'FocusLost', 'BufRead', 'BufNewFile' },
    config = require('pluginconfig.lualine').setup,
  },
  {
    "j-hui/fidget.nvim",
    version = '*',
    event = 'LspAttach',
    cond = not vim.g.vscode,
    config = function ()
      require('fidget').setup({
        notification = {
          window = {
            winblend = 0,
            x_padding = 1,
            y_padding = 1,
          },
        },
      })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    cond = not vim.g.vscode,
    version = '*',
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = require('pluginconfig.bufferline').setup,
  },
  {
    'b0o/incline.nvim',
    cond = not vim.g.vscode,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      local devicons = require 'nvim-web-devicons'
      require('incline').setup {
        -- based on https://github.com/b0o/incline.nvim/discussions/32
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
          if filename == '' then
            filename = '[No Name]'
          end
          local ft_icon, ft_color = devicons.get_icon_color(filename)

          local function get_diagnostic_label()
            local icons = { error = '󰅚 ', warn = '󰀪 ', hint = '󰌶 ', info = ' ' }
            local label = {}

            for severity, icon in pairs(icons) do
              local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
              if n > 0 then
                table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity })
              end
            end
            if #label > 0 then
              table.insert(label, { '┊ ' })
            end
            return label
          end

          return {
            { get_diagnostic_label() },
            { (ft_icon or '') .. ' ', guifg = ft_color, guibg = 'none' },
            { filename .. ' ', gui = vim.bo[props.buf].modified and 'bold,italic' or 'bold' },
          }
        end,
      }
    end
  },
  {
    'stevearc/aerial.nvim',
    -- FIXME: tree-sitter throws in javascript file after aerial.nvim v1.5.0
    version = 'v1.4.0',
    cond = not vim.g.vscode,
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
      local palette = require("colors").palette
      require('scrollbar').setup({
        marks = {
          Search = { color_nr = '3', color = palette.yellow },
          Error = { color_nr = '9', color = palette.red },
          Warn = { color_nr = '11', color = palette.peach },
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
    version = '*',
    event = 'VeryLazy',
    config = require('pluginconfig.which-key').setup,
  },
  {
    'mvllow/modes.nvim',
    cond = not vim.g.vscode,
    version = '*',
    event = { 'CursorMoved', 'CursorMovedI' },
    config = require('pluginconfig.modes').setup,
  },
  {
    "shellRaining/hlchunk.nvim",
    cond = not vim.g.vscode,
    version = '*',
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      local palette = require('colors').palette
      require("hlchunk").setup({
        chunk = {
          style = {
            { fg = palette.sapphire },
            { fg = palette.red },
          }
        },
        indent = { enable = true },
        line_num = { enable = false },
        blank = { enable = false },
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
  {
    'brenoprata10/nvim-highlight-colors',
    cond = not vim.g.vscode,
    event = { 'BufReadPost', 'BufAdd', 'BufNewFile' },
    config = function()
      require('nvim-highlight-colors').setup({
        render = 'virtual',
        virtual_symbol = ' ■',
        enable_named_colors = false,
        enable_tailwind = true,
      })
    end
  },
  -- Filer
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    cond = not vim.g.vscode,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = require('pluginconfig.tree').keys,
    config = require('pluginconfig.tree').setup,
  },
  -- Editor
  {
    'windwp/nvim-autopairs',
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
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
    version = '*',
    cond = not vim.g.vscode,
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
    version = '*',
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
      local palette = require('colors').palette
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = string.format("highlight IlluminatedWordText ctermbg=238 guibg=%s", palette.surface1)
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = string.format("highlight IlluminatedWordRead ctermbg=238 guibg=%s", palette.surface1)
      })
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = string.format("highlight IlluminatedWordWrite ctermbg=238 guibg=%s", palette.surface1)
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
      local palette = require('colors').palette
      vim.api.nvim_create_autocmd('Colorscheme', {
        pattern = '*',
        command = string.format('highlight ExtraWhitespace guibg=%s', palette.red)
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
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
    lazy = true,
    keys = {
      {  '<C-q>', function() require('bufdelete').bufdelete(0, false) end, mode = 'n', noremap = true, desc = 'Buffer: Delete' }
    }
  },
  {
    'rapan931/lasterisk.nvim',
    keys = {
      {
        '*',
        function()
          require('lasterisk').search()
          if package.loaded['hlslens'] then
            require('hlslens').start()
          end
        end,
        mode = 'n'
      },
      {
        'g*',
        function()
          require('lasterisk').search({ is_whole = false })
          if package.loaded['hlslens'] then
            require('hlslens').start()
          end
        end,
        mode = { 'n', 'x' }
      },
    },
  },
  -- lang
  {
    'vuki656/package-info.nvim',
    cond = not vim.g.vscode,
    dependencies = { 'MunifTanjim/nui.nvim' },
    ft = 'json',
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
  {
    'jxnblk/vim-mdx-js',
    cond = not vim.g.vscode,
  },
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
if not vim.g.vscode then
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = 'highlight! link DiagnosticHint LineNr'
  })

  -- reset semantic highlight
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    callback = function()
      local types = { 'variable', 'parameter', 'property', 'function' }
      for _, typ in pairs(types) do
        vim.api.nvim_set_hl(0, '@lsp.type.' .. typ, {})
      end
    end
  })

  local palette = require('colors').palette

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
    command = string.format('highlight NormalFloat guibg=%s', palette.mantle)
  })
  vim.api.nvim_create_autocmd('Colorscheme', {
    pattern = '*',
    command = string.format('highlight FloatBorder guibg=%s blend=20', palette.mantle)
  })
  vim.opt.termguicolors = true
  vim.opt.winblend = 20
  vim.opt.pumblend = 20
  vim.cmd.colorscheme('catppuccin')
end
