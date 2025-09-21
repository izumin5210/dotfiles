return {
  {
    "stevearc/aerial.nvim",
    version = "*",
    lazy = true,
    config = true,
  },
  {
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
  },
  {
    "folke/which-key.nvim",
    version = "*",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function()
      local wk = require("which-key")
      wk.setup({
        plugins = {
          presets = {
            operators = false,
          },
        },
      })
      wk.add({
        { "<leader>g", group = "+Go to File, Code or GitHub" },
        { "<leader>t", group = "+Test" },
        { "<leader>d", group = "+Debug" },
        { "<leader>c", group = "+Comment, Code" },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        ft = "go",
        config = require("plugins.editor.config.dap").setup_go,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
    },
    keys = require("plugins.editor.config.dap").keys,
    config = require("plugins.editor.config.dap").setup,
  },
  {
    "nvim-neotest/neotest",
    version = "*",
    dependencies = {
      { "nvim-neotest/nvim-nio", version = "*" },
      "plenary.nvim",
      "nvim-treesitter",
      -- adapters
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    config = require("plugins.editor.config.neotest").setup,
    keys = require("plugins.editor.config.neotest").keys,
  },
  {
    "folke/todo-comments.nvim",
    version = "*",
    event = { "VeryLazy" },
    dependencies = { "plenary.nvim" },
    opts = {
      highlight = { after = "" },
    },
  },
  -- Buffers
  {
    "famiu/bufdelete.nvim",
    lazy = true,
    keys = {
      {
        "<C-q>",
        function()
          require("bufdelete").bufdelete(0, false)
        end,
        mode = "n",
        noremap = true,
        desc = "Buffer: Delete",
      },
    },
  },
  {
    "chrisgrieser/nvim-early-retirement",
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 20,
    },
  },
  {
    "linrongbin16/gitlinker.nvim",
    version = "*",
    cmd = "GitLink",
    keys = {
      { "<leader>gl", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Git: yank git permalink" },
      { "<leader>gL", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Git: open git permalink" },
    },
    opts = {},
  },
  -- Highlight
  {
    "kevinhwang91/nvim-hlslens",
    dependencies = { "nvim-scrollbar" },
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    init = function()
      require("utils.highlight").force_set_highlights("nvim-hlslens_hl", {
        HlSearchLens = { link = "DiagnosticHint" },
        HlSearchLensNear = { link = "DiagnosticInfo" },
      })
    end,
    config = function()
      require("scrollbar.handlers.search").setup({})
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    version = "*",
    dependencies = { "nvim-scrollbar" },
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    init = function()
      require("utils.highlight").force_set_highlights("gitsigns_hl", {
        SignColumn = { ctermbg = "none", bg = "none" },
        GitGutterAdd = { ctermbg = "none", bg = "none" },
        GitGutterChange = { ctermbg = "none", bg = "none" },
        GitGutterDelete = { ctermbg = "none", bg = "none" },
      })
    end,
    config = function()
      require("gitsigns").setup()
      require("scrollbar.handlers.gitsigns").setup()
    end,
  },
  {
    "zbirenbaum/neodim",
    event = "LspAttach",
    config = true,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    opts = {
      render = "virtual",
      virtual_symbol = "■",
      enable_named_colors = false,
      enable_tailwind = true,
      exclude_filetypes = {
        "dashboard",
        "lazy",
        "blink-cmp-menu",
      },
    },
  },
  {
    "RRethy/vim-illuminate",
    event = { "CursorMoved", "CursorMovedI" },
    init = function()
      local palette = require("utils.colors").palette
      require("utils.highlight").force_set_highlights("vim-illuminate_hl", {
        IlluminatedWordText = { ctermbg = 238, bg = palette.surface1 },
        IlluminatedWordRead = { ctermbg = 238, bg = palette.surface1 },
        IlluminatedWordWrite = { ctermbg = 238, bg = palette.surface1 },
      })
    end,
    config = function()
      require("illuminate").configure()
    end,
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
