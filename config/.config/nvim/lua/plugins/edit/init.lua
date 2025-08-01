return {
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
        dependencies = {
          "zbirenbaum/copilot.lua",
          opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
          },
        },
        opts = {
          method = "getCompletionsCycling",
        },
      },
      {
        "L3MON4D3/LuaSnip",
        version = "*",
        build = "make install_jsregexp",
        dependencies = {
          "saadparwaiz1/cmp_luasnip",
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
        opts = { friendly_snippets = true },
      },
      "Snikimonkd/cmp-go-pkgs",
      {
        "onsails/lspkind.nvim",
        config = function()
          require("lspkind").init({
            symbol_map = {
              Copilot = "",
            },
          })
        end,
      },
    },
    keys = require("plugins.edit.config.nvim-cmp").keys,
    init = require("plugins.edit.config.nvim-cmp").init,
    config = require("plugins.edit.config.nvim-cmp").setup,
  },
  {
    "copilotlsp-nvim/copilot-lsp",
    dependencies = { "dotfiles-node-tools" },
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot_ls")
      vim.keymap.set("n", "<tab>", function()
        -- Try to jump to the start of the suggestion edit.
        -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
        local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
          or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
      end)
    end,
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    config = true,
  },
  {
    "folke/flash.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
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
    "numToStr/Comment.nvim",
    cond = not vim.g.vscode,
    dependencies = { "nvim-ts-context-commentstring" },
    keys = {
      { "<Leader>/", mode = { "n", "x" } },
      { "<Leader>?", mode = { "n", "x" } },
    },
    opts = function()
      return {
        toggler = {
          line = "<Leader>/",
          block = "<Leader>?",
        },
        opleader = {
          line = "<Leader>/",
          block = "<Leader>?",
        },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "danymat/neogen",
    version = "*",
    cond = not vim.g.vscode,
    keys = {
      {
        "<Leader>cn",
        function()
          require("neogen").generate()
        end,
        mode = "n",
        desc = "Generate doc comment",
      },
    },
    dependencies = { "nvim-treesitter" },
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
    "monaqa/dial.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = require("plugins.edit.config.dial").keys,
    config = require("plugins.edit.config.dial").setup,
  },
  {
    "rapan931/lasterisk.nvim",
    keys = {
      {
        "*",
        function()
          require("lasterisk").search({ is_whole = true, silent = true })
          if package.loaded["hlslens"] then
            require("hlslens").start()
          end
        end,
        mode = "n",
      },
      {
        "g*",
        function()
          require("lasterisk").search({ is_whole = false, silent = true })
          if package.loaded["hlslens"] then
            require("hlslens").start()
          end
        end,
        mode = { "n", "x" },
      },
    },
  },
  {
    "max397574/better-escape.nvim",
    opts = {
      timeout = 100,
      default_mappings = false,
      mappings = {
        i = { j = { k = "<ESC>" } },
        t = {
          j = {
            k = function()
              local bufname = vim.api.nvim_buf_get_name(0)
              local filetype = vim.bo.filetype
              if filetype == "claude-code" then
                vim.api.nvim_input("<Cmd>ClaudeCode<CR>")
              elseif bufname:match(":lazygit;") then
                vim.api.nvim_input("<ESC>")
              else
                vim.api.nvim_input("<C-\\><C-n>")
              end
            end,
          },
        },
      },
    },
  },
}
