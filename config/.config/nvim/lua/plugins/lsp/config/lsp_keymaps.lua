---@param bufnr integer
---@return { [1]: string|string[], [2]: string, [3]: string|function, desc: string }[]
local function get_keymaps(bufnr)
  local format = function()
    vim.lsp.buf.format({ async = true, bufnr = bufnr, timeout_ms = 10000 })
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

  local go_to_definition = function()
    require("overlook.api").peek_definition()
  end

  ---@see https://github.com/folke/snacks.nvim/issues/463#issuecomment-2787053205
  ---@param mode "in"|"out"
  local lsp_calls = function(mode)
    require("snacks").picker.pick({
      title = mode == "in" and "LSP Incoming Calls" or "LSP Outgoing Calls",
      finder = function(opts, ctx)
        local lsp = require("snacks.picker.source.lsp")
        local Async = require("snacks.picker.util.async")
        local win = ctx.filter.current_win
        local buf = ctx.filter.current_buf
        local bufmap = lsp.bufmap()

        ---@async
        ---@param cb async fun(item: snacks.picker.finder.Item)
        return function(cb)
          local async = Async.running()
          local cancel = {} ---@type fun()[]

          async:on(
            "abort",
            vim.schedule_wrap(function()
              vim.tbl_map(pcall, cancel)
              cancel = {}
            end)
          )

          vim.schedule(function()
            -- First prepare the call hierarchy
            local clients = lsp.get_clients(buf, "textDocument/prepareCallHierarchy")
            if vim.tbl_isempty(clients) then
              return async:resume()
            end

            local remaining = #clients
            for _, client in ipairs(clients) do
              local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
              local status, request_id = client:request("textDocument/prepareCallHierarchy", params, function(_, result)
                if result and not vim.tbl_isempty(result) then
                  -- Then get incoming calls for each item
                  local call_remaining = #result
                  if call_remaining == 0 then
                    remaining = remaining - 1
                    if remaining == 0 then
                      async:resume()
                    end
                    return
                  end

                  for _, item in ipairs(result) do
                    local call_params = { item = item }
                    local call_status, call_request_id = client:request(
                      mode == "in" and "callHierarchy/incomingCalls" or "callHierarchy/outgoingCalls",
                      call_params,
                      function(_, calls)
                        if calls then
                          for _, call in ipairs(calls) do
                            ---@type snacks.picker.finder.Item
                            local item = {
                              text = call.from.name .. "    " .. call.from.detail,
                              kind = lsp.symbol_kind(call.from.kind),
                              line = "    " .. call.from.detail,
                            }
                            local loc = {
                              uri = call.from.uri,
                              range = call.from.range,
                            }
                            lsp.add_loc(item, loc, client)
                            item.buf = bufmap[item.file]
                            item.text = item.file .. "    " .. call.from.detail
                            ---@diagnostic disable-next-line: await-in-sync
                            cb(item)
                          end
                        end
                        call_remaining = call_remaining - 1
                        if call_remaining == 0 then
                          remaining = remaining - 1
                          if remaining == 0 then
                            async:resume()
                          end
                        end
                      end
                    )
                    if call_status and call_request_id then
                      table.insert(cancel, function()
                        client:cancel_request(call_request_id)
                      end)
                    end
                  end
                else
                  remaining = remaining - 1
                  if remaining == 0 then
                    async:resume()
                  end
                end
              end)
              if status and request_id then
                table.insert(cancel, function()
                  client:cancel_request(request_id)
                end)
              end
            end
          end)

          async:suspend()
          cancel = {}
          async = Async.nop()
        end
      end,
    })
  end

  -- stylua: ignore
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
    -- see buffer lcoal mappings in https://github.com/neovim/nvim-lspconfig#suggested-configuration
    { "n", "gD", vim.lsp.buf.declaration, desc = "Go to Declarations" },
    { "n", "gd", go_to_definition, desc = "Go to Definitions" },
    { "n", "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Show Hover Card" },
    { "n", "gI", Snacks.picker.lsp_implementations, desc = "Go to Implementations" },
    { { "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, desc = "Show Signature Help" },
    { "n", "gy", Snacks.picker.lsp_type_definitions, desc = "Go to Type Definitions" },
    { "n", "<space>cr", "<cmd>Lspsaga rename ++project<CR>", desc = "Rename Symbol" },
    { { "n", "v" }, "<space>.", "<cmd>Lspsaga code_action<CR>", desc = "Code Action" },
    { "n", "gr", Snacks.picker.lsp_references, desc = "Go to References" },
    { "n", "<space>cf", format, desc = "Format Document" },
    -- custom mappings
    { "n", "gs", Snacks.picker.lsp_symbols, desc = "Go to Symbols in Document" },
    { "n", "gS", Snacks.picker.lsp_workspace_symbols, desc = "Search Symbols in Workspace" },
    { "n", "gi", function() lsp_calls("in") end, desc = "Incoming Calls", },
    { "n", "go", function() lsp_calls("out") end, desc = "Outgoing Calls", },
    { "n", "<leader>uh", toggle_inlay_hint, desc = "Toggle Inlay Hints" },
  }

  return keymaps
end

return { get_keymaps = get_keymaps }
