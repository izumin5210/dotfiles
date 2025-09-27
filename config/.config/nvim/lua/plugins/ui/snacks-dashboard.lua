return {
  "snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      width = 90,
      preset = {
        keys = {
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
        },
        header = "",
      },
      formats = {
        -- remove cwd from file path, shorten path if too long
        file = function(item, ctx)
          local fname = vim.fn.fnamemodify(item.file, ":.")
          fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname

          if #fname > ctx.width then
            local dir = vim.fn.fnamemodify(fname, ":h")
            local file = vim.fn.fnamemodify(fname, ":t")
            if dir and file then
              file = file:sub(-(ctx.width - #dir - 2))
              fname = dir .. "/…" .. file
            end
          end
          local dir, file = fname:match("^(.*)/(.+)$")
          return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
        end,
      },
      sections = {
        { section = "header", padding = 3 },
        {
          section = "keys",
          gap = 1,
          padding = 2,
        },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          cwd = true,
          indent = 2,
          padding = 2,
        },
        { section = "startup" },
      },
    },
    _inits = {
      function()
        local palette = require("utils.colors").palette
        require("utils.highlight").set_highlights("snacks-dashboard_hl", {
          SnacksDashboardIcon = { fg = palette.sapphire },
          SnacksDashboardDesc = { fg = palette.sky },
          SnacksDashboardFile = { fg = palette.blue },
          SnacksDashboardFooter = { fg = palette.subtext0 },
          SnacksDashboardSpecial = { fg = palette.flamingo },
          SnacksDashboardKey = { fg = palette.mauve },
        })
      end,
    },
  },
  opts_extend = { "_inits" },
}
