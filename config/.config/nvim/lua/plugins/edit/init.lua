return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
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
      {
        "fang2hou/blink-copilot",
      },
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
          suggestion = { enabled = false },
          panel = { enabled = false },
          filetypes = {
            markdown = true,
            help = true,
          },
        },
      },
    },
    init = function()
      local palette = require("utils.colors").palette
      -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu
      require("utils.highlight").force_set_highlights("blink_cmp_hl", {
        BlinkCmpMenu = { fg = palette.text, bg = palette.surface0 },
      })
    end,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "enter",
        ["<C-y>"] = { "select_and_accept" },
        ["<C-n>"] = { "select_next", "show", "fallback_to_mappings" },
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true },
        ghost_text = { enabled = true },
        list = {
          selection = { preselect = true },
        },
        menu = {
          draw = {
            padding = 2,
            gap = 2,
            treesitter = { "lsp" },
            columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "kind_name" } },
            components = {
              kind_name = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.kind
                end,
                highlight = "BlinkCmpSource",
              },

              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  if ctx.item.source_name == "LSP" then
                    local color_item =
                      require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr ~= "" then
                      icon = color_item.abbr
                    end
                  end

                  return icon .. ctx.icon_gap
                end,

                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end

                  if ctx.item.source_name == "LSP" then
                    local color_item =
                      require("nvim-highlight-colors").format(ctx.item.documentation, { kind = ctx.kind })
                    if color_item and color_item.abbr_hl_group then
                      hl = color_item.abbr_hl_group
                    end
                  end

                  return hl
                end,
              },
            },
          },
        },
      },

      sources = {
        default = { "copilot", "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
          },
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },

      fuzzy = { implementation = "prefer_rust_with_warning" },

      cmdline = { enabled = false },
    },
    opts_extend = { "sources.default" },
  },
  {
    "copilotlsp-nvim/copilot-lsp",
    cond = not vim.g.vscode,
    init = function()
      vim.g.copilot_nes_debounce = 500
      vim.lsp.enable("copilot_ls")
      vim.keymap.set("n", "<tab>", function()
        -- Try to jump to the start of the suggestion edit.
        -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
        local _ = require("copilot-lsp.nes").walk_cursor_start_edit()
          or (require("copilot-lsp.nes").apply_pending_nes() and require("copilot-lsp.nes").walk_cursor_end_edit())
      end)
      -- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
      vim.keymap.set("n", "<esc>", function()
        if not require("copilot-lsp.nes").clear() then
          -- fallback to other functionality
        end
      end, { desc = "Clear Copilot suggestion or fallback" })
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
    opts = {
      modes = {
        char = {
          keys = { "f", "F", "t", "T" },
          char_actions = function(motion)
            return {
              -- only clever-f style
              [motion:lower()] = "next",
              [motion:upper()] = "prev",
            }
          end,
        },
      },
    },
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
          j = { k = "<C-\\><C-n>" },
        },
      },
    },
  },
}
