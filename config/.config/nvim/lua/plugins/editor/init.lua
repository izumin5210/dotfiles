return {
  {
    "stevearc/aerial.nvim",
    version = "*",
    lazy = true,
    config = true,
    keys = {
      {
        "<leader>cs",
        mode = "n",
        function()
          require("aerial").snacks_picker()
        end,
        desc = "Code: Toggle Symbols Outline",
      },
    },
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
}
