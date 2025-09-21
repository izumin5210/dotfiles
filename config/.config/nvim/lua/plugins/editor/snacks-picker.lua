return {
  "snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      enable = true,
      prompt = "   ",
      formatters = {
        file = { icon_width = 3 },
      },
      layouts = {
        default = {
          layout = {
            box = "horizontal",
            border = "none",
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
              box = "vertical",
              border = "none",
              {
                win = "input",
                height = 1,
                border = { " ", " ", " ", " ", " ", " ", " ", " " },
                title = "{title} {live} {flags}",
              },
              {
                win = "list",
                border = { " ", " ", " ", " ", " ", " ", " ", " " },
                wo = { signcolumn = "yes:1" }, -- left padding
              },
            },
            {
              win = "preview",
              title = "{preview}",
              border = { " ", " ", " ", " ", " ", " ", " ", " " },
              width = 0.5,
              wo = { number = false },
            },
          },
        },
      },
    },
    _inits = {
      function()
        local palette = require("utils.colors").palette
        require("utils.highlight").set_highlights("snacks-picker_hl", {
          SnacksPickerPrompt = { fg = palette.sky },
          SnacksPickerInput = { bg = palette.mantle },
          SnacksPickerInputBorder = { bg = palette.mantle },
        })
      end,
    },
  },
  opts_extend = { "_inits" },
  keys = {
    {
      "<leader><leader>",
      mode = "n",
      noremap = true,
      desc = "Files: Open files",
      function()
        local picker = require("snacks").picker
        local root = require("snacks.git").get_root()
        if root == nil then
          picker.files({
            matcher = { frecency = true },
          })
        else
          picker.git_files({
            untracked = true,
            matcher = { frecency = true },
            cwd = vim.uv.cwd(),
          })
        end
      end,
    },
    {
      "<leader>gg",
      mode = "n",
      noremap = true,
      desc = "Files: Grep",
      function()
        require("snacks").picker.grep({ hidden = true })
      end,
    },
  },
}
