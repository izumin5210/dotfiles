return {
  -- Libraries
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = true,
  },
  {
    "mortepau/codicons.nvim", -- required by config function for nvim-dap
    lazy = true,
    init = function()
      vim.g.codicons_extension_cmp_disable = true
    end,
  },
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
    version = "*",
  },
  {
    "MunifTanjim/nui.nvim",
    version = "*",
    lazy = true,
  },
  {
    "tpope/vim-repeat", -- required by leap.nvim
    vscode = true,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
  },
  -- Appearance
  {
    "catppuccin/nvim",
    version = "*",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "frappe",
      transparent_background = true,
      integrations = {
        dap = true,
        dap_ui = true,
        flash = true,
        gitsigns = true,
        grug_far = true,
        lsp_saga = true,
        neotest = true,
        noice = true,
        notify = true,
        treesitter_context = true,
        snacks = { enabled = true },
        illuminate = { enabled = true, lsp = true },
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  -- misc
  {
    "folke/snacks.nvim",
    version = "*",
    lazy = false, -- for dashboard
    ---@type snacks.Config
    opts = {
      scratch = { enable = true },
      styles = {
        scratch = {
          wo = {
            winhighlight = "", -- use usual NormalFloat
          },
        },
        terminal = {
          keys = {
            term_normal = false, -- disable <ESC><ESC> for claudecode
          },
        },
      },
    },
    config = function(_, opts)
      for _, fn in ipairs(opts._inits or {}) do
        pcall(fn)
      end
      require("snacks").setup(opts)
    end,
  },
  {
    "folke/persistence.nvim",
    version = "*",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },
  {
    "alexghergh/nvim-tmux-navigation",
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
