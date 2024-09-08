return {
  -- Libraries
  {
    "nvim-tree/nvim-web-devicons", -- required by lualine and nvim-tree.lua
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
    "akinsho/bufferline.nvim",
    cond = not vim.g.vscode,
    event = "VimEnter",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("rc.pluginconfig.bufferline").setup()
    end,
  },
  {
    "folke/noice.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = {
      { "MunifTanjim/nui.nvim", version = "*" },
      {
        "rcarriga/nvim-notify",
        version = "*",
        init = function()
          local palette = require("rc.colors").palette
          require("rc.utils").set_highlights("nvim-notify_hl", {
            NotifyBackground = { bg = palette.base },
            NotifyERRORBorder = { bg = palette.base },
            NotifyERRORBody = { bg = palette.base },
            NotifyWARNBorder = { bg = palette.base },
            NotifyWARNBody = { bg = palette.base },
            NotifyINFOBorder = { bg = palette.base },
            NotifyINFOBody = { bg = palette.base },
            NotifyDEBUGBorder = { bg = palette.base },
            NotifyDEBUGBody = { bg = palette.base },
            NotifyTRACEBorder = { bg = palette.base },
            NotifyTRACEBody = { bg = palette.base },
          })
        end,
        opts = {
          render = "wrapped-compact",
          stages = "static",
          timeout = 3000,
          max_height = function()
            return math.floor(vim.o.lines * 0.75)
          end,
          max_width = function()
            return math.floor(vim.o.columns * 0.50)
          end,
        },
      },
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
        signature = { enabled = true },
        progress = { enabled = true },
        hover = { enabled = false }, -- use lspsaga
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
      routes = {
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
      },
      messages = {
        view_search = false, -- use hlslens
      },
      views = {
        cmdline_popup = {
          border = { style = "none", padding = { 1, 3 } },
          win_options = {
            winhighlight = { NormalFloat = "NoiceCmdlinePopupNormal", FloatBorder = "NoiceCmdlinePopupBorder" },
          },
        },
        cmdline_popupmenu = {
          border = { style = "none", padding = { 1, 3 } },
          win_options = {
            winhighlight = { NormalFloat = "NoiceCmdlinePopupmenuNormal", FloatBorder = "NoiceCmdlinePopupmenuBorder" },
          },
        },
      },
    },
    init = function()
      local palette = require("rc.colors").palette

      require("rc.utils").set_highlights("noice_hl", {
        NoiceCmdlinePopupNormal = { link = "NormalFloat" },
        NoiceCmdlinePopupBorder = { link = "FloatBorder" },
        NoiceCmdlinePopupmenuNormal = { fg = palette.text, bg = palette.mantle },
        NoiceCmdlinePopupmenuBorder = { fg = palette.text, bg = palette.mantle },
      })
    end,
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
    dependencies = { "MunifTanjim/nui.nvim", version = "*" },
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
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    cond = not vim.g.vscode,
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        config = {
          -- stylua: ignore
          shortcut = {
            { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
          },
          project = { enable = false },
          mru = { cwd_only = true },
          header = {},
          footer = {},
        },
      })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },
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
