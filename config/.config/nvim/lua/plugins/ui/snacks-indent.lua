return {
  "snacks.nvim",
  ---@type snacks.Config
  opts = {
    indent = {
      enabled = true,
      animate = {
        enabled = true,
        duration = { total = 300 },
      },
      scope = { enabeld = true },
      chunk = { enabled = true },
    },
    _inits = {
      function()
        local colors = require("utils.colors")
        local palette = require("utils.colors").palette
        require("utils.highlight").set_highlights("snacks-indent_hl", {
          SnacksIndent = { fg = palette.surface0 },
          SnacksIndentScope = { fg = colors.alpha_blend(palette.sapphire, palette.base, 0.75) },
        })
      end,
    },
  },
  opts_extend = { "_inits" },
}
