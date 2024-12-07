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

    CmpItemKindCopilot = { fg = palette.text, bg = palette.lavender },
  })
end

-- https://github.com/zbirenbaum/copilot-cmp/tree/b6e5286?tab=readme-ov-file#tab-completion-configuration-highly-recommended
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

function M.setup()
  local cmp = require("cmp")

  cmp.setup({
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      -- https://github.com/zbirenbaum/copilot-cmp/tree/b6e5286?tab=readme-ov-file#tab-completion-configuration-highly-recommended
      ["<Tab>"] = vim.schedule_wrap(function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end),
      -- ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = "copilot", group_index = 1, priority = 1000 },
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
