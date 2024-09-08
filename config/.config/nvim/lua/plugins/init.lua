return {
  -- Libraries
  {
    "nvim-tree/nvim-web-devicons",
    cond = not vim.g.vscode,
    lazy = true,
    config = true,
  },
  {
    "mortepau/codicons.nvim", -- required by config function for nvim-dap
    cond = not vim.g.vscode,
    lazy = true,
  },
  {
    "nvim-lua/plenary.nvim",
    cond = not vim.g.vscode,
    lazy = true,
    version = "*",
  },
  {
    "MunifTanjim/nui.nvim",
    version = "*",
    cond = not vim.g.vscode,
    lazy = true,
  },
  {
    "tpope/vim-repeat", -- required by leap.nvim
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  },
  {
    "folke/ts-comments.nvim",
    cond = not vim.g.vscode,
    version = "*",
    opts = {},
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  },
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    cond = not vim.g.vscode,
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        ft = "go",
        config = require("rc.pluginconfig.dap").setup_go,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
    },
    keys = require("rc.pluginconfig.dap").keys,
    config = require("rc.pluginconfig.dap").setup,
  },
  {
    "nvim-neotest/neotest",
    version = "*",
    cond = not vim.g.vscode,
    dependencies = {
      { "nvim-neotest/nvim-nio", version = "*" },
      "nvim-lua/plenary.nvim",
      "nvim-treesitter",
      -- adapters
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    config = require("rc.pluginconfig.neotest").setup,
    keys = require("rc.pluginconfig.neotest").keys,
  },
  -- Appearance
  {
    "catppuccin/nvim",
    version = "*",
    name = "catppuccin",
    cond = not vim.g.vscode,
    priority = 1000,
    opts = {
      flavour = "frappe",
      transparent_background = true,
      integrations = {
        aerial = true,
        lsp_saga = true,
        mason = true,
        neotest = true,
        noice = true,
        notify = true,
        which_key = true,
      },
    },
  },
  -- Editor
  -- lang
  {
    "vuki656/package-info.nvim",
    cond = not vim.g.vscode,
    dependencies = { "nui.nvim" },
    event = { "BufEnter package.json" },
    init = function()
      require("rc.utils").force_set_highlights("package-info_hl", {
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
  -- misc
  {
    "folke/persistence.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },
  {
    "alexghergh/nvim-tmux-navigation",
    cond = not vim.g.vscode,
    keys = {
      {
        "<C-w>h",
        function()
          require("nvim-tmux-navigation").NvimTmuxNavigateLeft()
        end,
        mode = "n",
        noremap = true,
      },
      {
        "<C-w>j",
        function()
          require("nvim-tmux-navigation").NvimTmuxNavigateDown()
        end,
        mode = "n",
        noremap = true,
      },
      {
        "<C-w>k",
        function()
          require("nvim-tmux-navigation").NvimTmuxNavigateUp()
        end,
        mode = "n",
        noremap = true,
      },
      {
        "<C-w>l",
        function()
          require("nvim-tmux-navigation").NvimTmuxNavigateRight()
        end,
        mode = "n",
        noremap = true,
      },
      {
        "<C-w>\\",
        function()
          require("nvim-tmux-navigation").NvimTmuxNavigateLastActive()
        end,
        mode = "n",
        noremap = true,
      },
      {
        "<C-w>Space",
        function()
          require("nvim-tmux-navigation").NvimTmuxNavigateNext()
        end,
        mode = "n",
        noremap = true,
      },
    },
    opts = {
      disable_when_zoomed = true,
    },
  },
  {
    "folke/lazydev.nvim",
    version = "*",
    cond = not vim.g.vscode,
    ft = "lua",
    dependencies = {
      { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    },
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
}
