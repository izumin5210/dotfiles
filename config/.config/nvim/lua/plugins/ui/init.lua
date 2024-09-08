return {
  {
    "akinsho/bufferline.nvim",
    cond = not vim.g.vscode,
    event = { "VeryLazy" },
    version = "*",
    dependencies = {
      -- "nvim-web-devicons", -- depends but it will be load automatically
    },
    opts = function()
      return require("plugins.ui.config.bufferline").opts()
    end,
  },
  {
    "folke/noice.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = { "VeryLazy" },
    dependencies = {
      "nui.nvim",
      {
        "rcarriga/nvim-notify",
        version = "*",
        init = function()
          local palette = require("utils.colors").palette
          require("utils.highlight").set_highlights("nvim-notify_hl", {
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
      local palette = require("utils.colors").palette

      require("utils.highlight").set_highlights("noice_hl", {
        NoiceCmdlinePopupNormal = { link = "NormalFloat" },
        NoiceCmdlinePopupBorder = { link = "FloatBorder" },
        NoiceCmdlinePopupmenuNormal = { fg = palette.text, bg = palette.mantle },
        NoiceCmdlinePopupmenuBorder = { fg = palette.text, bg = palette.mantle },
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
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
    dependencies = {
      -- "nvim-web-devicons", -- depends but it will be load automatically
    },
  },
}
