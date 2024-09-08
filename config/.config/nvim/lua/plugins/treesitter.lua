return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    cond = not vim.g.vscode,
    event = { "BufReadPre" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "cue",
          -- 'diff',
          "dockerfile",
          "git_config",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "gomod",
          "gosum",
          "gowork",
          "graphql",
          "hcl",
          "html",
          "javascript",
          "jq",
          "jsdoc",
          "json",
          "json5",
          "jsonnet",
          "lua",
          "make",
          "markdown",
          "markdown_inline", -- required by lspsaga.nvim
          "prisma",
          "proto",
          "python",
          "regex",
          "ruby",
          "rust",
          "scss",
          "sql",
          "starlark",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vue",
          "yaml",
        },
        -- indent = {
        --   enable = true,
        -- },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        context_commentstring = {
          enable_autocmd = false,
        },
        matchup = {
          enable = true,
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    cond = not vim.g.vscode,
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
    init = function()
      local palette = require("rc.colors").palette

      require("rc.utils").force_set_highlights("treesitter-context_hl", {
        TreesitterContext = { bg = palette.surface1, blend = 10 },
      })
    end,
    opts = {
      max_lines = 4,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects", -- required by nvim-surround
    cond = not vim.g.vscode,
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
  },
  {
    "haringsrob/nvim_context_vt",
    cond = not vim.g.vscode,
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
    init = function()
      require("rc.utils").force_set_highlights("context_vt_hl", {
        ContextVt = { link = "DiagnosticHint" },
      })
    end,
    opts = {
      min_rows = 3,
    },
  },
  {
    "andymass/vim-matchup",
    version = "*",
    cond = not vim.g.vscode,
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    cond = not vim.g.vscode,
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
    },
  },
}
