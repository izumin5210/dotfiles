---@param bufnr integer
---@return { [1]: string|string[], [2]: string, [3]: string|function, desc: string }[]
local function get_keymaps(bufnr)
  local ts_builtin = require("telescope.builtin")

  local format = function()
    vim.lsp.buf.format({ async = true, bufnr = bufnr, timeout_ms = 10000 })
  end

  local show_diagnostics = function()
    require("telescope.builtin").diagnostics({ bufnr = bufnr })
  end

  ---@param is_next'next'|'prev'
  ---@param severity 'ERROR'|'WARN'|nil
  local get_diagnostic_goto = function(is_next, severity)
    return function()
      local severity_num = vim.diagnostic.severity[severity]
      if is_next == "next" then
        require("lspsaga.diagnostic"):goto_next({ severity = severity_num })
      else
        require("lspsaga.diagnostic"):goto_prev({ severity = severity_num })
      end
      vim.api.nvim_feedkeys("zz", "n", false)
    end
  end

  local toggle_inlay_hint = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end

  ---@type { [1]: string|string[], [2]: string, [3]: string | function, desc: string }[]
  local keymaps = {
    -- see global mappings in https://github.com/neovim/nvim-lspconfig#suggested-configuration
    { "n", "<space>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Show Line Diagnostics" },
    { "n", "[d", get_diagnostic_goto("prev"), desc = "Go to prev Diagnostic" },
    { "n", "]d", get_diagnostic_goto("next"), desc = "Go to next Diagnostic" },
    { "n", "[e", get_diagnostic_goto("prev", "ERROR"), desc = "Go to prev Error" },
    { "n", "]e", get_diagnostic_goto("next", "ERROR"), desc = "Go to next Error" },
    { "n", "[w", get_diagnostic_goto("prev", "WARN"), desc = "Go to prev Diagnostic(warn)" },
    { "n", "]w", get_diagnostic_goto("next", "WARN"), desc = "Go to next Diagnostic(warn)" },
    { "n", "<space>q", show_diagnostics, desc = "Show Diagnostics in Document" },
    -- see buffer lcoal mappings in https://github.com/neovim/nvim-lspconfig#suggested-configuration
    { "n", "gD", vim.lsp.buf.declaration, desc = "Go to Declarations" },
    { "n", "gd", ts_builtin.lsp_definitions, desc = "Go to Definitions" },
    { "n", "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Show Hover Card" },
    { "n", "gi", ts_builtin.lsp_implementations, desc = "Go to Implementations" },
    { { "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, desc = "Show Signature Help" },
    { "n", "<space>D", ts_builtin.lsp_type_definitions, desc = "Go to Type Definitions" },
    { "n", "<space>cr", "<cmd>Lspsaga rename ++project<CR>", desc = "Rename Symbol" },
    { { "n", "v" }, "<space>.", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
    { "n", "gr", ts_builtin.lsp_references, desc = "Go to References" },
    { "n", "<space>cf", format, desc = "Format Document" },
    -- custom mappings
    { "n", "gs", ts_builtin.lsp_document_symbols, desc = "Go to Symbols in Document" },
    { "n", "gS", ts_builtin.lsp_dynamic_workspace_symbols, desc = "Search Symbols in Workspace" },
    { "n", "gci", ts_builtin.lsp_incoming_calls, desc = "Incoming Calls" },
    { "n", "gco", ts_builtin.lsp_outgoing_calls, desc = "Outgoing Calls" },
    { "n", "<leader>uh", toggle_inlay_hint, desc = "Toggle Inlay Hints" },
  }

  return keymaps
end

return { get_keymaps = get_keymaps }
