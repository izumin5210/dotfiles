return {
  {
    "stevearc/aerial.nvim",
    version = "*",
    cond = not vim.g.vscode,
    lazy = true,
    config = true,
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cond = not vim.g.vscode,
    dependencies = { "nvim-web-devicons" },
    keys = function()
      return require("plugins.editor.config.nvim-tree").keys()
    end,
    opts = function()
      return require("plugins.editor.config.nvim-tree").opts()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    cond = not vim.g.vscode,
    dependencies = {
      "plenary.nvim",
      {
        "prochri/telescope-all-recent.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        opts = {},
      },
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "otavioschwanck/telescope-alternate.nvim",
      "aerial.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },
    cmd = "Telescope",
    keys = function()
      ---@param name string
      ---@return function
      local function action(name)
        return require("plugins.editor.config.telescope").actions[name]
      end
      return require("utils.keymap").lazy_keymap({
        {
          { "n", "<leader><leader>", action("find_files"), desc = "File: Go to ..." },
          { "n", "<leader>g/", action("grep"), desc = "File: Grep" },
          { "n", "<leader>gs", action("git_status"), desc = "File: Git Suatus" },
          { "n", "<leader>gu", action("conflicted_files"), desc = "File: Git Unmerged Files" },
          { "n", "<leader>gb", action("buffers"), desc = "File: Buffers" },
          { "n", "<leader>ga", action("alternate_files"), desc = "File: Alternate" },
          { "n", "<leader>gf", action("aerial"), desc = "LSP: Functions and Methods" },
        },
        common = { noremap = true },
      })
    end,
    init = function()
      require("plugins.editor.config.telescope").init()
    end,
    config = function()
      require("plugins.editor.config.telescope").setup()
    end,
  },
  {
    "folke/which-key.nvim",
    version = "*",
    cond = not vim.g.vscode,
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
        { "<leader>c", group = "+Comment" },
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
    event = { "VeryLazy" },
    dependencies = { "plenary.nvim" },
    opts = {
      highlight = { after = "" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<leader>gg",
        mode = "n",
        noremap = true,
        desc = "Git: open Lazygit",
        function()
          require("plugins.editor.config.toggleterm").toggle_lazygit()
        end,
      },
    },
    cmd = { "ToggleTerm" },
    opts = {
      highlights = {
        NormalFloat = { link = "NormalFloat" },
        FloatBorder = { link = "FloatBorder" },
      },
      float_opts = {
        border = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
    },
  },
  -- Buffers
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
  {
    "linrongbin16/gitlinker.nvim",
    cmd = "GitLink",
    keys = {
      { "<leader>gl", "<cmd>GitLink<cr>", mode = { "n", "v" }, desc = "Git: yank git permalink" },
      { "<leader>gL", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Git: open git permalink" },
    },
    opts = {},
  },
  -- Highlight
  {
    "petertriho/nvim-scrollbar",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    opts = function()
      local palette = require("utils.colors").palette
      return {
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
      }
    end,
  },
  {
    "kevinhwang91/nvim-hlslens",
    cond = not vim.g.vscode,
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
    cond = not vim.g.vscode,
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
    "mvllow/modes.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = { "CursorMoved", "CursorMovedI" },
    opts = function()
      local palette = require("utils.colors").palette
      return {
        colors = {
          copy = palette.yellow,
          delete = palette.red,
          insert = palette.sky,
          visual = palette.mauve,
        },
        line_opacity = {
          copy = 0.4,
          delete = 0.4,
          insert = 0.4,
          visual = 0.4,
        },
      }
    end,
  },
  {
    "shellRaining/hlchunk.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    opts = function()
      local palette = require("utils.colors").palette
      local exclude_filetypes = {
        aerial = true,
        dashboard = true,
        ["rip-substitute"] = true,
        TelescopeResults = true,
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
  {
    "RRethy/vim-illuminate",
    cond = not vim.g.vscode,
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
    "ntpeters/vim-better-whitespace",
    cond = not vim.g.vscode,
    event = { "VeryLazy" },
    init = function()
      local palette = require("utils.colors").palette
      require("utils.highlight").force_set_highlights("vim-better-whitespace_hl", {
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
}
