return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      -- main branch stores queries under runtime/queries/, which lazy.nvim
      -- doesn't add to rtp. Without this, vim.treesitter.start() can't find
      -- highlight queries for most languages.
      local plugin_dir = vim.fn.fnamemodify(
        vim.api.nvim_get_runtime_file("lua/nvim-treesitter/init.lua", false)[1],
        ":h:h:h"
      )
      vim.opt.runtimepath:append(plugin_dir .. "/runtime")

      require("nvim-treesitter").install({
        "bash",
        "css",
        "cue",
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
      })

      -- Neovim 0.12 only enables treesitter highlighting by default for a few filetypes.
      -- Enable it for all filetypes that have a parser available.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
    init = function()
      local palette = require("utils.colors").palette

      require("utils.highlight").force_set_highlights("treesitter-context_hl", {
        TreesitterContext = { bg = palette.surface1, blend = 10 },
      })
    end,
    opts = {
      max_lines = 4,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects", -- required by nvim-surround
    branch = "main",
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
  },
  {
    "haringsrob/nvim_context_vt",
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
    init = function()
      require("utils.highlight").force_set_highlights("context_vt_hl", {
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
    event = { "BufReadPre" },
    dependencies = { "nvim-treesitter" },
    config = function()
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  {
    "windwp/nvim-ts-autotag",
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
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = { enable_autocmd = false },
  },
}
