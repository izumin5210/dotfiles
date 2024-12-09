return {
  {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = { -- load after mason.nvim and mason-lspconfig.nvim
      "mason.nvim",
      {
        "williamboman/mason-lspconfig.nvim",
        cond = not vim.g.vscode,
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        dependencies = { "mason.nvim" }, -- load after mason.nvim
        version = "*",
        opts = function()
          return {
            ensure_installed = {
              "bashls",
              "dockerls",
              "graphql",
              "jsonnet_ls",
              "rust_analyzer",
              -- Ruby
              "solargraph",
              -- JS
              "biome",
              "eslint",
              "ts_ls",
              "volar",
              "prismals",
              "denols",
              -- CSS
              "cssls",
              "tailwindcss",
              -- Go
              "gopls",
              "golangci_lint_ls",
              -- Python
              "pyright",
              -- Lua
              "lua_ls",
              -- JSON (JSON Schema)
              "jsonls",
              "yamlls",
            },
            automatic_installation = false,
            handlers = {
              require("plugins.lsp.config.lsp_setup"),
            },
          }
        end,
      },
    },
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
      local utils = require("plugins.lsp.config.utils")

      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        ---@param args { buf: integer }
        callback = function(args)
          local actions = require("plugins.lsp.config.lsp_actions_on_save")
          utils.run_lsp_actions(actions, { buf = args.buf })
        end,
      })

      -- language servers are installed manually
      local server_names = { "buf_ls", "nixd" }
      for _, server_name in ipairs(server_names) do
        require("plugins.lsp.config.lsp_setup")(server_name)
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    version = "*",
    cond = not vim.g.vscode,
    cmd = "Mason",
    opts = {},
  },
  {
    "nvimtools/none-ls.nvim",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    opts = function()
      local null_ls = require("null-ls")
      return {
        -- Primary Source of Truth is null-ls.
        sources = {
          -- JavaScript
          null_ls.builtins.formatting.prettierd.with({
            condition = function(utils)
              return not utils.root_has_file({ "biome.json", "biome.jsonc", "deno.json", "deno.jsonc" })
            end,
          }),
          -- Protocol Buffers
          null_ls.builtins.diagnostics.buf,
          null_ls.builtins.formatting.buf,
          -- Dockerfile
          null_ls.builtins.diagnostics.hadolint,
          -- GitHub Actions
          null_ls.builtins.diagnostics.actionlint,
          -- ShellScript
          null_ls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "2" },
          }),
          -- Lua
          null_ls.builtins.formatting.stylua,
          -- not supported by mason
          -- Nix
          null_ls.builtins.formatting.nixfmt,
        },
        debug = true,
      }
    end,
  },
  {
    "jayp0521/mason-null-ls.nvim",
    version = "*",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    -- load after none-ls.nvim because primary source of truth is none-ls
    dependencies = { "mason.nvim", "none-ls.nvim" },
    opts = {
      ensure_installed = nil,
      automatic_installation = true,
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    cond = not vim.g.vscode,
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
}
