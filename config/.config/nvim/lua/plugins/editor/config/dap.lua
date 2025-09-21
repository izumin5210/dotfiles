local M = {}

local actions = {
  continue = function()
    require("dap").continue()
  end,
  step_over = function()
    require("dap").step_over()
  end,
  step_into = function()
    require("dap").step_into()
  end,
  step_out = function()
    require("dap").step_out()
  end,
  toggle_bp = function()
    require("dap").toggle_breakpoint()
  end,
  set_bp_cond = function()
    require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end,
  toggle_repl = function()
    require("dap").repl.toggle()
  end,
  run_to_cursor = function()
    require("dap").run_to_cursor()
  end,
  run_last = function()
    require("dap").run_last()
  end,
  -- show_variables = function()
  --   require("telescope").extensions["dap"].variables()
  -- end,
  -- show_frames = function()
  --   require("telescope").extensions["dap"].frames()
  -- end,
  -- show_commands = function()
  --   require("telescope").extensions["dap"].commands()
  -- end,
  terminate = function()
    require("dap").terminate()
  end,
}

M.keys = require("utils.keymap").lazy_keymap({
  {
    { "n", "<Leader>dc", actions.continue, desc = "Continue" },
    { "n", "<Leader>dC", actions.continue, desc = "Run to Curosr" },
    { "n", "<Leader>dO", actions.step_over, desc = "Step over" },
    { "n", "<Leader>di", actions.step_into, desc = "Step into" },
    { "n", "<Leader>do", actions.step_out, desc = "Step out" },
    { "n", "<Leader>db", actions.toggle_bp, desc = "Toggle breakpoint" },
    { "n", "<Leader>dB", actions.set_bp_cond, desc = "Add conditional breakpoint" },
    { "n", "<Leader>dr", actions.toggle_repl, desc = "Open REPL" },
    { "n", "<Leader>dl", actions.run_last, desc = "Re-run the last debug adapter" },
    -- { "n", "<Leader>dv", actions.show_variables, desc = "Show variables" },
    -- { "n", "<Leader>df", actions.show_frames, desc = "Show frames" },
    -- { "n", "<Leader>d<space>", actions.show_commands, desc = "Show commands" },
    { "n", "<Leader>dt", actions.terminate, desc = "Close" },
  },
  desc_prefix = "Debug",
  common = { noremap = true, silent = true },
})

function M.setup()
  local codicons = require("codicons")
  vim.fn.sign_define(
    "DapBreakpoint",
    { text = codicons.get("circle-filled"), texthl = "Error", linehl = "", numhl = "" }
  )
  vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = codicons.get("debug-breakpoint-conditional"), texthl = "Error", linehl = "", numhl = "" }
  )
  vim.fn.sign_define(
    "DapLogPoint",
    { text = codicons.get("debug-breakpoint-log"), texthl = "Error", linehl = "", numhl = "" }
  )
  vim.fn.sign_define("DapStopped", { text = codicons.get("stop-circle"), texthl = "Error", linehl = "", numhl = "" })
  vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = codicons.get("debug-breakpoint-unsupported"), texthl = "Error", linehl = "", numhl = "" }
  )
end

function M.setup_go()
  require("dap-go").setup({
    dap_configurations = {
      {
        type = "go",
        name = "Attach remote",
        mode = "remote",
        request = "attach",
      },
    },
    delve = {
      initialize_timeout_sec = 20,
      port = "${port}",
    },
  })
end

function M.status()
  return require("dap").status()
end

function M.is_loaded()
  return package.loaded["dap"] ~= nil and #(require("dap").status()) > 0
end

return M
