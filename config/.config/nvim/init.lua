-----------------------------------
-- Editor
-----------------------------------
vim.opt.updatetime = 2000

-- edit
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.wrap = false

-- completion
vim.opt.completeopt = "menu,menuone,noselect"

-- show whitespace chars
vim.opt.list = true
vim.opt.listchars = "tab:│─,trail:_,extends:»,precedes:«,nbsp:･"

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- clipboard
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard = "unnamed,unnamedplus"
else
  vim.opt.clipboard = "unnamed"
end

-- indent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable builtin tablne
vim.opt.showtabline = 0

-- disable builtin matchit.vim and matchparen.vim
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- hide cmdline
vim.opt.cmdheight = 0

-- sign
vim.opt.signcolumn = "yes"

-- lsp
vim.diagnostic.config({ virtual_text = false })

-----------------------------------
-- Keymaps
-----------------------------------
vim.g.mapleader = " "
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR><Esc>", { noremap = true, desc = "Search: Clear Search Highlight" })

-- buffers
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, desc = "Buffer: Prev" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, desc = "Buffer: Next" })
vim.keymap.set("n", "[b", ":bprevious<CR>", { noremap = true, desc = "Buffer: Prev" })
vim.keymap.set("n", "]b", ":bnext<CR>", { noremap = true, desc = "Buffer: Next" })
-- <C-q> to delete buffer using bufdelete.nvim

if vim.g.vscode then
  vim.keymap.set("n", "gi", function()
    require("vscode-neovim").call("editor.action.goToImplementation")
  end, { noremap = true, desc = "Go to implementation" })
  vim.keymap.set("n", "[d", function()
    require("vscode-neovim").call("editor.action.marker.prev")
  end, { noremap = true, desc = "Go to prev Diagnostic" })
  vim.keymap.set("n", "]d", function()
    require("vscode-neovim").call("editor.action.marker.next")
  end, { noremap = true, desc = "Go to next Diagnostic" })
  vim.keymap.set("n", "<leader>rn", function()
    require("vscode-neovim").call("editor.action.rename")
  end, { noremap = true, desc = "Rename Symbol" })
  vim.keymap.set("n", "<leader>q", function()
    require("vscode-neovim").call("workbench.actions.view.problems")
  end, { noremap = true, desc = "Show Diagnostics list" })
end

-----------------------------------
-- Plugins
-----------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
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
  -- LSP
  {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        version = "*",
        dependencies = {
          { "folke/neoconf.nvim", opts = { local_settings = ".nvim/neoconf.json" } },
          { "folke/neodev.nvim", opts = {} },
        },
      },
      {
        "williamboman/mason.nvim",
        version = "*",
        config = true,
      },
      {
        "nvimtools/none-ls.nvim",
        config = require("pluginconfig.lspconfig").setup_null_ls,
      },
      {
        "jayp0521/mason-null-ls.nvim",
        version = "*",
        config = require("pluginconfig.lspconfig").setup_mason_null_ls,
      },
      {
        "ray-x/lsp_signature.nvim",
        init = require("pluginconfig.lspconfig").init_lsp_signature,
        config = require("pluginconfig.lspconfig").setup_lsp_signature,
      },
      {
        "nvimdev/lspsaga.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = { "LspAttach" },
        config = require("pluginconfig.lspconfig").setup_lspsaga,
      },
    },
    init = require("pluginconfig.lspconfig").init,
    config = require("pluginconfig.lspconfig").setup,
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
      "hrsh7th/cmp-cmdline",
      {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = require("pluginconfig.cmp").setup_copilot_cmp,
      },
      {
        "onsails/lspkind.nvim",
        config = require("pluginconfig.cmp").setup_lspkind,
      },
    },
    keys = require("pluginconfig.cmp").keys,
    init = require("pluginconfig.cmp").init,
    config = require("pluginconfig.cmp").setup,
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
        init = require("pluginconfig.treesitter").init_treesitter_context,
        config = require("pluginconfig.treesitter").setup_treesitter_context,
      },
      "nvim-treesitter/nvim-treesitter-textobjects", -- required by nvim-surround
      {
        "haringsrob/nvim_context_vt",
        init = require("pluginconfig.treesitter").init_context_vt,
        config = require("pluginconfig.treesitter").setup_context_vt,
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
    config = require("pluginconfig.treesitter").setup,
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
    keys = require("pluginconfig.telescope").keys,
    config = require("pluginconfig.telescope").setup,
  },
  -- Debugger
  {
    "mfussenegger/nvim-dap",
    cond = not vim.g.vscode,
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        ft = "go",
        config = require("pluginconfig.dap").setup_go,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
    },
    keys = require("pluginconfig.dap").keys,
    config = require("pluginconfig.dap").setup,
  },
  {
    "nvim-neotest/neotest",
    version = "*",
    cond = not vim.g.vscode,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- adapters
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    config = require("pluginconfig.neotest").setup,
    keys = require("pluginconfig.neotest").keys,
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
        fidget = true,
        lsp_saga = true,
        mason = true,
        neotest = true,
        which_key = true,
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    version = "*",
    event = "LspAttach",
    cond = not vim.g.vscode,
    opts = {
      notification = {
        window = {
          winblend = 0,
          x_padding = 1,
          y_padding = 1,
        },
      },
    },
  },
  {
    "b0o/incline.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = require("pluginconfig.incline").setup,
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
      local palette = require("colors").palette
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
      require("utils").force_set_highlights("nvim-hlslens_hl", {
        HlSearchLens = { link = "DiagnosticHint" },
        HlSearchLensNear = { link = "DiagnosticHint" },
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
      require("utils").force_set_highlights("gitsigns_hl", {
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
    config = require("pluginconfig.which-key").setup,
  },
  {
    "mvllow/modes.nvim",
    cond = not vim.g.vscode,
    version = "*",
    event = { "CursorMoved", "CursorMovedI" },
    config = require("pluginconfig.modes").setup,
  },
  {
    "shellRaining/hlchunk.nvim",
    cond = not vim.g.vscode,
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local palette = require("colors").palette
      require("hlchunk").setup({
        chunk = {
          style = {
            { fg = palette.sapphire },
            { fg = palette.red },
          },
        },
        indent = { enable = true },
        line_num = { enable = false },
        blank = { enable = false },
      })
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
    },
  },
  -- Filer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cond = not vim.g.vscode,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = require("pluginconfig.tree").keys,
    config = require("pluginconfig.tree").setup,
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
      retirementAgeMins = 480, -- 8h
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
    cond = not vim.g.vscode,
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = { after = "" },
    },
  },
  {
    "RRethy/vim-illuminate",
    cond = not vim.g.vscode,
    event = { "CursorMoved", "CursorMovedI" },
    init = function()
      local palette = require("colors").palette
      require("utils").force_set_highlights("vim-illuminate_hl", {
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
      local palette = require("colors").palette
      require("utils").force_set_highlights("vim-illuminate_hl", {
        ExtraWhitespace = { bg = palette.red },
      })
    end,
    config = function()
      vim.g.better_whitespace_enabled = 1
      vim.g.strip_whitespace_on_save = 1
      vim.g.strip_whitespace_confirm = 0
      vim.g.better_whitespace_filetypes_blacklist = {
        "dashboard",
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
    keys = require("pluginconfig.dial").keys,
    config = require("pluginconfig.dial").setup,
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
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    init = function()
      require("utils").force_set_highlights("vim-illuminate_hl", {
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
  {
    "jxnblk/vim-mdx-js",
    cond = not vim.g.vscode,
  },
  -- misc
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
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
})

-----------------------------------
-- Appearance
-----------------------------------
if not vim.g.vscode then
  local palette = require("colors").palette

  require("utils").set_highlights("hl_for_non_vscode", {
    -- clear statusline
    StatusLine = { link = "LineNr" },
    StatusLineNc = { link = "LineNr" },
    -- clear bg
    Normal = { ctermbg = "none", bg = "none" },
    NonText = { ctermbg = "none", bg = "none" },
    LineNr = { ctermbg = "none", bg = "none" },
    Folded = { ctermbg = "none", bg = "none" },
    EndOfBuffer = { ctermbg = "none", bg = "none" },
    -- floating
    NormalFloat = { bg = palette.mantle },
    FloatBorder = { bg = palette.mantle, blend = 20 },
  })

  require("utils").force_set_highlights("force_hl_for_non_vscode", {
    DiagnosticHint = { link = "LineNr" },
    -- reset semantic highlight
    ["@lsp.type.variable"] = {},
    ["@lsp.type.parameter"] = {},
    ["@lsp.type.property"] = {},
    ["@lsp.type.function"] = {},
  })

  -- clear statusline
  vim.opt.laststatus = 0
  vim.opt.statusline = string.rep("─", vim.api.nvim_win_get_width(0))

  vim.opt.termguicolors = true
  vim.opt.winblend = 20
  vim.opt.pumblend = 20
  vim.cmd.colorscheme("catppuccin")
end
