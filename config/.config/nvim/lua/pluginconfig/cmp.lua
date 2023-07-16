local M = {}

M.keys = require('utils').lazy_keymap({
  {
    { 'i', '<C-x><C-o>', function() require('cmp').complete() end, noremap = true },
  }
})

function M.setup_copilot_cmp()
  require('copilot').setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
  })
  require('copilot_cmp').setup({
    method = 'getCompletionsCycling',
  })
end

function M.setup_lspkind()
  require('lspkind').init({
    symbol_map = {
      Copilot = '',
    },
  })
end

function M.init()
  local augroup = vim.api.nvim_create_augroup('cmp_init', { clear = true })

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
  local tbl = {
    CmpItemAbbrDeprecated = { fg = '#6b7089', bg = 'NONE', fmt = 'strikethrough' },
    CmpItemAbbrMatch = { fg = '#91acd1', bg = 'NONE', fmt = 'bold' },
    CmpItemAbbrMatchFuzzy = { fg = '#91acd1', bg = 'NONE', fmt = 'bold' },
    CmpItemMenu = { fg = '#ada0d3', bg = 'NONE', fmt = 'italic' },

    CmpItemKindField = { fg = '#c6c8d1', bg = '#e27878' },
    CmpItemKindProperty = { fg = '#c6c8d1', bg = '#e27878' },
    CmpItemKindEvent = { fg = '#c6c8d1', bg = '#e27878' },

    CmpItemKindText = { fg = '#c6c8d1', bg = '#b4be82' },
    CmpItemKindEnum = { fg = '#c6c8d1', bg = '#b4be82' },
    CmpItemKindKeyword = { fg = '#c6c8d1', bg = '#b4be82' },

    CmpItemKindConstant = { fg = '#c6c8d1', bg = '#e2a478' },
    CmpItemKindConstructor = { fg = '#c6c8d1', bg = '#e2a478' },
    CmpItemKindReference = { fg = '#c6c8d1', bg = '#e2a478' },

    CmpItemKindFunction = { fg = '#c6c8d1', bg = '#a093c7' },
    CmpItemKindStruct = { fg = '#c6c8d1', bg = '#a093c7' },
    CmpItemKindClass = { fg = '#c6c8d1', bg = '#a093c7' },
    CmpItemKindModule = { fg = '#c6c8d1', bg = '#a093c7' },
    CmpItemKindOperator = { fg = '#c6c8d1', bg = '#a093c7' },

    CmpItemKindVariable = { fg = '#c6c8d1', bg = '#6b7089' },
    CmpItemKindFile = { fg = '#c6c8d1', bg = '#6b7089' },

    CmpItemKindUnit = { fg = '#c6c8d1', bg = '#6b7089' },
    CmpItemKindSnippet = { fg = '#c6c8d1', bg = '#6b7089' },
    CmpItemKindFolder = { fg = '#c6c8d1', bg = '#6b7089' },

    CmpItemKindMethod = { fg = '#c6c8d1', bg = '#84a0c6' },
    CmpItemKindValue = { fg = '#c6c8d1', bg = '#84a0c6' },
    CmpItemKindEnumMember = { fg = '#c6c8d1', bg = '#84a0c6' },

    CmpItemKindInterface = { fg = '#c6c8d1', bg = '#89b8c2' },
    CmpItemKindColor = { fg = '#c6c8d1', bg = '#89b8c2' },
    CmpItemKindTypeParameter = { fg = '#c6c8d1', bg = '#89b8c2' },

    CmpItemKindCopilot = { fg = '#c6c8d1', bg = '#a093c7' },
  }

  for key, colors in pairs(tbl) do
    vim.api.nvim_create_autocmd('Colorscheme', {
      group = augroup,
      pattern = '*',
      command = 'highlight ' .. key .. ' guifg=' .. colors['fg'] .. ' guibg=' .. colors['bg'],
    })
  end
end

function M.setup()
  local cmp = require('cmp')

  cmp.setup({
    enabled = function()
      local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
      return buftype ~= 'prompt'
    end,
    snippet = {
      expand = function(args)
        vim.fn['vsnip#anonymous'](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }), -- zbirenbaum/copilot-cmp
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'copilot' },
      { name = 'path' },
    }, {
      { name = 'buffer' },
    }),
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
    window = {
      completion = {
        winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,Search:None',
        col_offset = -3,
        side_padding = 0,
      },
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        local kind = require('lspkind').cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, '%s', { trimempty = true })
        kind.kind = ' ' .. (strings[1] or '') .. ' '
        kind.menu = '    (' .. (strings[2] or '') .. ')'

        return kind
      end,
    },
  })

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { 'Man', '!' }
        }
      }
    })
  })

  -- for nvim-autopairs
  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
  )
end

return M
