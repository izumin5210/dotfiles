return {
  "snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = {
      enabled = true,
      width = 90,
      formats = {
        file = function(item, ctx)
          -- カレントディレクトリからの相対パスを取得
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
        -- { section = "header" },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          cwd = true, -- 現在のディレクトリのファイルのみ
          indent = 2,
          padding = 1,
        },
        {
          action = function()
            require("persistence").load()
          end,
          desc = "Restore Session",
          icon = " ",
          key = "s",
          padding = 1,
        },
        { section = "startup" },
      },
    },
  },
}
