return {
  {
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = { "blink.cmp" },
    init = function()
      local colors = require("utils.colors")
      local palette = colors.palette

      require("utils.highlight").force_set_highlights("lspconfig_hl", {
        LspInlayHint = { link = "DiagnosticHint" },
        -- https://github.com/catppuccin/vscode/blob/catppuccin-vsc-v3.15.2/packages/catppuccin-vsc/src/theme/extensions/error-lens.ts
        DiagnosticErrorLine = { bg = colors.alpha_blend(palette.red, palette.base, 0.15) },
        DiagnosticWarnLine = { bg = colors.alpha_blend(palette.peach, palette.base, 0.15) },
        DiagnosticHintLine = { bg = colors.alpha_blend(palette.green, palette.base, 0.15) },
        DiagnosticInfoLine = { bg = colors.alpha_blend(palette.blue, palette.base, 0.15) },
      })

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
          linehl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticErrorLine",
            [vim.diagnostic.severity.WARN] = "DiagnosticWarnLine",
            [vim.diagnostic.severity.HINT] = "DiagnosticHintLine",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfoLine",
          },
        },
      })
    end,
    config = function()
      local augroup = vim.api.nvim_create_augroup("neovim_lspconfig_setup", { clear = true })

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        ---@param args { buf: integer }
        callback = function(args)
          require("plugins.lsp.config.lsp_actions_on_save")({ buf = args.buf })
        end,
      })

      vim.lsp.config("*", {
        on_attach = require("plugins.lsp.config.utils").on_attach_common,
        capabilities = require("blink.cmp").get_lsp_capabilities({
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        }),
      })

      vim.lsp.enable({
        -- Go
        "gopls",
        -- "golangci_lint_ls",

        -- JavaScript
        "biome",
        -- "denols",
        "eslint",
        "prismals",
        "tailwindcss",
        "vtsls",
        "vue_ls",

        -- JSON (JSON Schema)
        "jsonls",
        "jsonnet_ls",
        "yamlls",

        -- Others
        "gh_actions_ls",
        "bashls",
        "buf_ls",
        "dockerls",
        "graphql",
        "lua_ls",
        "nixd",
        "pyright",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    version = "*",
    lazy = true,
    opts = {
      formatters = {
        shfmt = { append_args = { "-i", "2" } },
      },
      -- stylua: ignore
      formatters_by_ft = {
        javascript      = { "biome", "prettierd", stop_after_first = true },
        typescript      = { "biome", "prettierd", stop_after_first = true },
        javascriptreact = { "biome", "prettierd", stop_after_first = true },
        typescriptreact = { "biome", "prettierd", stop_after_first = true },
        json            = { "biome", "prettierd", stop_after_first = true },
        jsonc           = { "biome", "prettierd", stop_after_first = true },
        lua             = { "stylua" },
        sh              = { "shfmt" },
        zsh             = { "shfmt" },
        nix             = { "nixfmt" },
      },
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    dependencies = { "nvim-web-devicons", "nvim-treesitter" },
    event = { "LspAttach" },
    init = function()
      local palette = require("utils.colors").palette
      require("utils.highlight").set_highlights("lspsaga_hl", {
        SagaNormal = { bg = palette.crust },
        SagaBorder = { bg = palette.crust },
      })
    end,
    opts = function()
      return {
        symbol_in_winbar = { enable = false },
        lightbulb = { enable = false },
        code_action = { show_server_name = true },
        ui = {
          -- create padding around the floating window
          border = { " ", " ", " ", " ", " ", " ", " ", " " },
          kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
        },
        scroll_preview = {
          scroll_down = "<Down>",
          scroll_up = "<Up>",
        },
      }
    end,
  },
  {
    "WilliamHsieh/overlook.nvim",
    opts = {},
    init = function()
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("overlook_enter_mapping", { clear = true }),
        pattern = "*",
        callback = function()
          vim.schedule(function()
            if vim.w.is_overlook_popup then
              -- open in orig window on enter
              vim.keymap.set("n", "<CR>", function()
                require("overlook.api").open_in_original_window()
              end, { buffer = true, desc = "Overlook: Open in original window" })

              -- open in vsplit on ctrl+enter
              for _, lhs in ipairs({ "<C-CR>", ";" }) do
                vim.keymap.set("n", lhs, function()
                  require("overlook.api").open_in_vsplit()
                end, { buffer = true, desc = "Overlook: Open in vertical split" })
              end
            end
          end)
        end,
      })
    end,
    keys = {
      {
        "<leader>pu",
        function()
          require("overlook.api").restore_popup()
        end,
        { desc = "Restore last popup" },
      },
      {
        "<leader>pU",
        function()
          require("overlook.api").restore_all_popups()
        end,
        { desc = "Restore all popups" },
      },
      {
        "<leader>pc",
        function()
          require("overlook.api").close_all()
        end,
        { desc = "Close all popups" },
      },
      {
        "<leader>ps",
        function()
          require("overlook.api").open_in_split()
        end,
        { desc = "Open popup in split" },
      },
      {
        "<leader>pv",
        function()
          require("overlook.api").open_in_vsplit()
        end,
        { desc = "Open popup in vsplit" },
      },
      {
        "<leader>pt",
        function()
          require("overlook.api").open_in_tab()
        end,
        { desc = "Open popup in tab" },
      },
      {
        "<leader>po",
        function()
          require("overlook.api").open_in_original_window()
        end,
        { desc = "Open popup in current window" },
      },
    },
  },
}
