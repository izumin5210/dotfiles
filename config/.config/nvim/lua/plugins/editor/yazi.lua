return {
  "mikavilpas/yazi.nvim",
  version = "*",
  lazy = true,
  dependencies = {
    { "plenary.nvim", lazy = true },
  },
  keys = {
    { "<leader>fe", mode = { "n" }, "<cmd>Yazi<cr>", desc = "Explorer (current file)" },
    { "<leader>fE", mode = { "n" }, "<cmd>Yazi cwd<cr>", desc = "Explorer (cwd)" },
  },
  ---@type YaziConfig | {}
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
    yazi_floating_window_border = { " ", " ", " ", " ", " ", " ", " ", " " },
  },
  init = function()
    vim.g.loaded_netrwPlugin = 1

    local palette = require("utils.colors").palette
    require("utils.highlight").set_highlights("yazi_hl", {
      YaziFloat = { bg = palette.mantle },
      YaziFloatBorder = { bg = palette.mantle },
    })
  end,
}
