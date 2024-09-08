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
  -- Completion
  {
    "hrsh7th/nvim-cmp",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = require("rc.pluginconfig.cmp").setup_copilot_cmp,
      },
      {
        "onsails/lspkind.nvim",
        config = require("rc.pluginconfig.cmp").setup_lspkind,
      },
    },
    keys = require("rc.pluginconfig.cmp").keys,
    init = require("rc.pluginconfig.cmp").init,
    config = require("rc.pluginconfig.cmp").setup,
  },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    cond = not vim.g.vscode,
    event = { "CursorHold", "CursorHoldI" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        init = require("rc.pluginconfig.treesitter").init_treesitter_context,
        config = require("rc.pluginconfig.treesitter").setup_treesitter_context,
      },
      "nvim-treesitter/nvim-treesitter-textobjects", -- required by nvim-surround
      {
        "haringsrob/nvim_context_vt",
        init = require("rc.pluginconfig.treesitter").init_context_vt,
        config = require("rc.pluginconfig.treesitter").setup_context_vt,
      },
      {
        "andymass/vim-matchup",
        version = "*",
      },
      {
        "windwp/nvim-ts-autotag",
        opts = {
          opts = {
            enable_close = true,
            enable_rename = true,
            enable_close_on_slash = true,
          },
        },
      },
    },
    config = require("rc.pluginconfig.treesitter").setup,
  },
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cond = not vim.g.vscode,
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "prochri/telescope-all-recent.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        opts = {},
      },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "otavioschwanck/telescope-alternate.nvim",
      "stevearc/aerial.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },
    cmd = "Telescope",
    keys = require("rc.pluginconfig.telescope").keys,
    init = require("rc.pluginconfig.telescope").init,
    config = require("rc.pluginconfig.telescope").setup,
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
      "nvim-treesitter/nvim-treesitter",
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
  {
    "stevearc/aerial.nvim",
    version = "*",
    cond = not vim.g.vscode,
    lazy = true,
    config = true,
  },
  {
    "petertriho/nvim-scrollbar",
    cond = not vim.g.vscode,
    event = "BufReadPost",
    config = function()
      local palette = require("rc.colors").palette
      require("scrollbar").setup({
        marks = {
          Search = { color_nr = "3", color = palette.yellow },
          Error = { color_nr = "9", color = palette.red },
          Warn = { color_nr = "11", color = palette.peach },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
        },
      })
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    cond = not vim.g.vscode,
    event = "BufReadPost",
    init = function()
      require("rc.utils").force_set_highlights("nvim-hlslens_hl", {
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
    cond = not vim.g.vscode,
    version = "*",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    init = function()
      require("rc.utils").force_set_highlights("gitsigns_hl", {
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
    "folke/which-key.nvim",
    cond = not vim.g.vscode,
    version = "*",
    event = "VeryLazy",
    config = require("rc.pluginconfig.which-key").setup,
  },
  {
    "mvllow/modes.nvim",
    cond = not vim.g.vscode,
    version = "*",
    event = { "CursorMoved", "CursorMovedI" },
    config = require("rc.pluginconfig.modes").setup,
  },
  {
    "shellRaining/hlchunk.nvim",
    cond = not vim.g.vscode,
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = function()
      local palette = require("rc.colors").palette
      local exclude_filetypes = {
        ["rip-substitute"] = true,
        ["TelescopeResults"] = true,
      }
      return {
        chunk = {
          enable = true,
          style = {
            { fg = palette.sapphire },
            { fg = palette.red },
          },
          delay = 0, -- disable animation
          exclude_filetypes = exclude_filetypes,
        },
        indent = { enable = true, exclude_filetypes = exclude_filetypes },
        line_num = { enable = false },
        blank = { enable = false },
      }
    end,
  },
  {
    "zbirenbaum/neodim",
    cond = not vim.g.vscode,
    event = "LspAttach",
    config = true,
  },
  {
    "brenoprata10/nvim-highlight-colors",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    opts = {
      render = "virtual",
      virtual_symbol = " ■",
      enable_named_colors = false,
      enable_tailwind = true,
      exclude_filetypes = {
        "dashboard",
        "lazy",
      },
    },
  },
  -- Filer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cond = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = require("rc.pluginconfig.tree").keys,
    config = require("rc.pluginconfig.tree").setup,
  },
  -- Buffer
  {
    "famiu/bufdelete.nvim",
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = {
      retirementAgeMins = 20,
    },
  },
  -- Editor
  {
    "windwp/nvim-autopairs",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    config = true,
  },
  {
    "folke/flash.nvim",
    version = "*",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "folke/ts-comments.nvim",
    version = "*",
    opts = {},
    event = "VeryLazy",
  },
  {
    "numToStr/Comment.nvim",
    cond = not vim.g.vscode,
    keys = { { "<Leader>/", mode = { "n", "v" } } },
    opts = {
      toggler = {
        line = "<Leader>/",
      },
      opleader = {
        line = "<Leader>/",
      },
    },
  },
  {
    "danymat/neogen",
    version = "*",
    cond = not vim.g.vscode,
    keys = {
      {
        "<Leader>cd",
        function()
          require("neogen").generate()
        end,
        mode = "n",
        desc = "Generate doc comment",
      },
    },
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      snippet_engine = "vsnip",
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = { "CursorHold", "CursorHoldI" },
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = { after = "" },
    },
  },
  {
    "chrisgrieser/nvim-rip-substitute",
    cond = not vim.g.vscode,
    cmd = "RipSubstitute",
    keys = {
      {
        "<leader>fs",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " rip substitute",
      },
    },
    opts = {
      popupWin = {
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
      prefill = {
        normal = false,
      },
    },
  },
  {
    "RRethy/vim-illuminate",
    cond = not vim.g.vscode,
    event = { "CursorMoved", "CursorMovedI" },
    init = function()
      local palette = require("rc.colors").palette
      require("rc.utils").force_set_highlights("vim-illuminate_hl", {
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
    "ntpeters/vim-better-whitespace",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    init = function()
      local palette = require("rc.colors").palette
      require("rc.utils").force_set_highlights("vim-better-whitespace_hl", {
        ExtraWhitespace = { bg = palette.red },
      })
    end,
    config = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_whitespace_confirm = 0
      vim.g.better_whitespace_filetypes_blacklist = {
        "dashboard",
        "lazy",
        -- default values
        "diff",
        "git",
        "gitcommit",
        "unite",
        "qf",
        "help",
        "markdown",
        "fugitive",
      }
    end,
  },
  {
    "dinhhuy258/git.nvim",
    cond = not vim.g.vscode,
    keys = {
      { "<Leader>go", desc = "Git: Open in GitHub" },
      { "<Leader>gp", desc = "Git: Open Pull Request Page" },
    },
    config = true,
  },
  {
    "monaqa/dial.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = require("rc.pluginconfig.dial").keys,
    config = require("rc.pluginconfig.dial").setup,
  },
  {
    "rapan931/lasterisk.nvim",
    keys = {
      {
        "*",
        function()
          require("lasterisk").search()
          if package.loaded["hlslens"] then
            require("hlslens").start()
          end
        end,
        mode = "n",
      },
      {
        "g*",
        function()
          require("lasterisk").search({ is_whole = false })
          if package.loaded["hlslens"] then
            require("hlslens").start()
          end
        end,
        mode = { "n", "x" },
      },
    },
  },
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
