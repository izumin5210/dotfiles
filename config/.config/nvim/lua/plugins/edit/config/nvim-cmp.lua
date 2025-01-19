local M = {}

M.keys = require("utils.keymap").lazy_keymap({
  {
    {
      "i",
      "<C-x><C-o>",
      function()
        require("cmp").complete()
      end,
      noremap = true,
    },
  },
})

function M.init()
  local palette = require("utils.colors").palette

  -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
  require("utils.highlight").force_set_highlights("cmp_hl", {
    CmpItemAbbrDeprecated = { fg = palette.overlay0, bg = "NONE", strikethrough = true },
    CmpItemAbbrMatch = { fg = palette.blue, bg = "NONE", bold = true },
    CmpItemAbbrMatchFuzzy = { fg = palette.blue, bg = "NONE", bold = true },
    CmpItemMenu = { fg = palette.mauve, bg = "NONE", italic = true },

    CmpItemKindField = { fg = palette.text, bg = palette.red },
    CmpItemKindProperty = { fg = palette.text, bg = palette.red },
    CmpItemKindEvent = { fg = palette.text, bg = palette.red },

    CmpItemKindText = { fg = palette.text, bg = palette.green },
    CmpItemKindEnum = { fg = palette.text, bg = palette.green },
    CmpItemKindKeyword = { fg = palette.text, bg = palette.green },

    CmpItemKindConstant = { fg = palette.text, bg = palette.yellow },
    CmpItemKindConstructor = { fg = palette.text, bg = palette.yellow },
    CmpItemKindReference = { fg = palette.text, bg = palette.yellow },

    CmpItemKindFunction = { fg = palette.text, bg = palette.mauve },
    CmpItemKindStruct = { fg = palette.text, bg = palette.mauve },
    CmpItemKindClass = { fg = palette.text, bg = palette.mauve },
    CmpItemKindModule = { fg = palette.text, bg = palette.mauve },
    CmpItemKindOperator = { fg = palette.text, bg = palette.mauve },

    CmpItemKindVariable = { fg = palette.text, bg = palette.overlay0 },
    CmpItemKindFile = { fg = palette.text, bg = palette.overlay0 },

    CmpItemKindUnit = { fg = palette.text, bg = palette.peach },
    CmpItemKindSnippet = { fg = palette.text, bg = palette.peach },
    CmpItemKindFolder = { fg = palette.text, bg = palette.peach },

    CmpItemKindMethod = { fg = palette.text, bg = palette.blue },
    CmpItemKindValue = { fg = palette.text, bg = palette.blue },
    CmpItemKindEnumMember = { fg = palette.text, bg = palette.blue },

    CmpItemKindInterface = { fg = palette.text, bg = palette.teal },
    CmpItemKindColor = { fg = palette.text, bg = palette.teal },
    CmpItemKindTypeParameter = { fg = palette.text, bg = palette.teal },
  })
end

function M.setup()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          if luasnip.expandable() then
            luasnip.expand()
          else
            cmp.confirm({ select = true })
          end
        else
          fallback()
        end
      end),
    }),
    sources = cmp.config.sources({
      { name = "luasnip", group_index = 1, priority = 100 },
      { name = "nvim_lsp", group_index = 1, priority = 100 },
      { name = "go_pkgs", group_index = 1, priority = 100 },
      { name = "path", group_index = 1, priority = 10 },
      { name = "buffer", group_index = 1, priority = 1 },
      { name = "lazydev", group_index = 0 },
    }),
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
    window = {
      completion = {
        winhighlight = "Normal:NormalFloat,FloatBorder:Pmenu,Search:None",
        col_offset = -3,
        side_padding = 0,
      },
    },
    matching = {
      -- for go_pkgs
      disallow_symbol_nonprefix_matching = false,
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"

        return kind
      end,
    },
    performance = {
      debounce = 500,
    },
  })

  -- for nvim-autopairs
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

return M
