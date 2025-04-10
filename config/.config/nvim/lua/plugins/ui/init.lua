return {
  {
    "b0o/incline.nvim",
    cond = not vim.g.vscode,
    event = { "VeryLazy" },
    opts = function()
      return require("plugins.ui.config.incline").opts()
    end,
  },
  {
    "rcarriga/nvim-notify",
    cond = not vim.g.vscode,
    version = "*",
    lazy = true,
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
  {
    "folke/noice.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = { "VeryLazy" },
    dependencies = {
      "nui.nvim",
      "nvim-notify",
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
        bottom_search = false, -- use a classic bottom cmdline for search
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
    "levouh/tint.nvim",
    dependencies = { "catppuccin" },
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = {
      highlight_ignore_patterns = {
        "VertSplit",
        "StatusLine",
        "StatusLineNC",
      },
      transforms = {
        ---@param r number
        ---@param g number
        ---@param b number
        ---@return number, number, number
        function(r, g, b, hl_group_info)
          local colors = require("utils.colors")
          local palette = colors.palette
          local hex = colors.alpha_blend(colors.rgb_to_hex({ r = r, g = g, b = b }), palette.base, 0.6)
          local rgb = colors.hex_to_rgb(hex)
          return rgb.r, rgb.g, rgb.b
        end,
      },
    },
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
    "ntpeters/vim-better-whitespace",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
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
  {
    "nvimdev/dashboard-nvim",
    cond = not vim.g.vscode,
    lazy = false,
    dependencies = {
      -- "nvim-web-devicons", -- depends but it will be load automatically
    },
    opts = {
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
    },
  },
}
