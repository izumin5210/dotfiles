local function smart_files()
  local picker = require("snacks").picker
  local root = require("snacks.git").get_root()
  local sources = require("snacks.picker.config.sources")

  local files = root == nil and sources.files
    or vim.tbl_deep_extend("force", sources.git_files, {
      untracked = true,
      cwd = vim.uv.cwd(),
    })

  picker({
    multi = { "buffers", "recent", files },
    format = "file",
    matcher = { frecency = true, sort_empty = true },
    filter = { cwd = true },
    transform = "unique_file",
  })
end

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
    { "<leader><leader>", mode = "n", noremap = true, desc = "Files: Open files", smart_files },
    {
      "<leader>gf",
      mode = "n",
      noremap = true,
      desc = "Files: Open files (only git-files)",
      function()
        require("snacks").picker.git_files()
      end,
    },
    {
      "<leader>gs",
      mode = "n",
      noremap = true,
      desc = "Git: Status",
      function()
        require("snacks").picker.git_status()
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
    {
      "<leader>sd",
      mode = "n",
      noremap = true,
      desc = "Search: Diagnostics",
      function()
        require("snacks").picker.diagnostics()
      end,
    },
    {
      "<leader>sD",
      desc = "Search: Buffer Diagnostics",
      noremap = true,
      function()
        require("snacks").picker.diagnostics()
      end,
    },
  },
}
