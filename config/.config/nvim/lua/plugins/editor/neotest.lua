return {
  "nvim-neotest/neotest",
  version = "*",
  dependencies = {
    { "nvim-neotest/nvim-nio", version = "*" },
    "plenary.nvim",
    "nvim-treesitter",
    -- adapters
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go"),
        require("neotest-jest"),
        require("neotest-vitest")({
          cwd = function(file)
            local util = require("neotest-vitest.util")
            return util.find_node_modules_ancestor(file)
          end,
          vitestCommand = function(file)
            local util = require("neotest-vitest.util")

            local function search_vitest_recursively(path)
              if path == "/" then
                return nil
              end

              local rootPath = util.find_node_modules_ancestor(path)
              local vitestBinary = util.path.join(rootPath, "node_modules", ".bin", "vitest")

              if util.path.exists(vitestBinary) then
                return vitestBinary
              end

              return search_vitest_recursively(util.path.dirname(path))
            end

            return search_vitest_recursively(util.path.dirname(file))
          end,
        }),
      },
    })
  end,
  keys = {
    {
      "<leader>tt",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File",
    },
    {
      "<leader>tT",
      function()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files",
    },
    {
      "<leader>tr",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run Last",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Show Output",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Output Panel",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop",
    },
  },
}
