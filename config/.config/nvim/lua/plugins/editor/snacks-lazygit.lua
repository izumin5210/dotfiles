return {
  "snacks.nvim",
  ---@type snacks.Config
  opts = {
    lazygit = {
      enable = true,
      configure = false,
    },
    styles = {
      lazygit = {
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
    },
  },
  keys = {
    {
      "<leader>lg",
      mode = "n",
      noremap = true,
      desc = "Git: Open Lazygit",
      function()
        _G.__snacks_last_lg = require("snacks").lazygit.open()
        _G._SNACKS_LG_CLOSE = function()
          local last_lg = _G.__snacks_last_lg
          if last_lg and last_lg.close then
            pcall(last_lg.close, last_lg)
          end
          _G.__snacks_last_lg = nil
        end
      end,
    },
  },
}
