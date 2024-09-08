return {
  -- lang
  {
    "vuki656/package-info.nvim",
    cond = not vim.g.vscode,
    dependencies = { "nui.nvim" },
    event = { "BufEnter package.json" },
    init = function()
      require("utils.highlight").force_set_highlights("package-info_hl", {
        PackageInfoOutdatedVersion = { link = "DiagnosticHint" },
        PackageInfoUpToDateVersion = { link = "DiagnosticHint" },
      })
    end,
    config = function()
      require("package-info").setup({
        autostart = true,
        hide_up_to_date = true,
        hide_unstable_version = true,
      })
      require("package-info").show()
    end,
  },
  -- Syntax Highlighting
  {
    "jxnblk/vim-mdx-js",
    cond = not vim.g.vscode,
  },
  {
    "direnv/direnv.vim",
    cond = not vim.g.vscode,
    ft = "direnv",
  },
}
