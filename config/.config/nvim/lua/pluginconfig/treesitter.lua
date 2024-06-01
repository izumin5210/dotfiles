local M = {}

function M.setup_treesitter_context()
  require("treesitter-context").setup({
    max_lines = 4,
  })
end

function M.init_treesitter_context()
  local palette = require("colors").palette

  require("utils").force_set_highlights("treesitter-context_hl", {
    TreesitterContext = { bg = palette.surface1, blend = 10 },
  })
end

function M.setup_context_vt()
  require("nvim_context_vt").setup({
    min_rows = 3,
  })
end

function M.init_context_vt()
  require("utils").force_set_highlights("context_vt_hl", {
    ContextVt = { link = "DiagnosticHint" },
  })
end

function M.setup()
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
end

return M
