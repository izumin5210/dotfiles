return {
  "3rd/diagram.nvim",
  dependencies = {
    { "3rd/image.nvim", opts = {} },
  },
  opts = {
    -- Disable automatic rendering for manual-only workflow
    events = {
      render_buffer = {}, -- Empty = no automatic rendering
      clear_buffer = { "BufLeave" },
    },
    renderer_options = {
      mermaid = {
        theme = "dark",
        scale = 2,
      },
    },
  },
  keys = {
    {
      "<CR>",
      function()
        require("diagram").show_diagram_hover()
      end,
      mode = "n",
      ft = { "markdown" },
      desc = "Show diagram in new tab",
    },
  },
}
