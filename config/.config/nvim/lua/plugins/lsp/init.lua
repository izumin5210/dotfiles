return {
  {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = { "dotfiles-node-tools" },
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
      local server_names = {
        -- Go
        "gopls",
        "golangci_lint_ls",
        -- JavaScript
        "denols",
        "eslint",
        "ts_ls",
        "volar",
        "prismals",
        -- CSS
        "cssls",
        "tailwindcss",
        -- Rust
        "rust_analyzer",
        -- JSON (JSON Schema)
        "jsonls",
        "jsonnet_ls",
        "yamlls",
        -- Others
        "bashls",
        "buf_ls",
        "dockerls",
        "graphql",
        "lua_ls",
        "nixd",
      }
      for _, server_name in ipairs(server_names) do
        require("plugins.lsp.config.lsp_setup")(server_name)
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    cond = not vim.g.vscode,
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = { "dotfiles-node-tools" },
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
      }
    end,
  },
  {
    name = "dotfiles-node-tools",
    cond = not vim.g.vscode,
    lazy = true,
    dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
    dependencies = { "nvim-lua/plenary.nvim" },
    build = "pnpm i",
    -- https://zenn.dev/vim_jp/articles/f24212092323d9
    config = function(spec)
      local Path = require("plenary.path")
      local dir = spec.dir
      local BIN_DIR = Path:new(dir, "node_modules", ".bin")

      vim.env.PATH = BIN_DIR:absolute() .. ":" .. vim.env.PATH
      vim.system({ "pnpm", "i" }, { cwd = dir, text = true })
    end,
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
  {
    "WilliamHsieh/overlook.nvim",
    opts = {},
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
