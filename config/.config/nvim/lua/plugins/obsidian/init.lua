---@param path_or_note obsidian.Note|string
local function open_in_scratch(path_or_note)
  local filename = type(path_or_note) == "string" and path_or_note or path_or_note.path.filename
  require("snacks.scratch").open({ file = filename, ft = "markdown" })
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    init = function()
      local grp = vim.api.nvim_create_augroup("obsidian_vault_markdown_policy", { clear = true })
      vim.api.nvim_create_autocmd({
        "BufReadPost",
        "BufNewFile",
        "BufFilePost",
        "BufEnter",
        "FileType",
      }, {
        group = grp,
        callback = function(args)
          local bufnr = args.buf
          if not vim.api.nvim_buf_is_valid(bufnr) then
            return
          end
          if vim.bo[bufnr].filetype ~= "markdown" then
            return
          end

          local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p")
          local enable = string.match(path, "^" .. vim.pesc(Obsidian.dir.filename) .. "/")

          -- enable render-markdown and cnoceallevel only if in Obsidian vaults
          vim.api.nvim_buf_call(bufnr, function()
            vim.opt_local.wrap = true
            if enable then
              vim.opt_local.conceallevel = 2
              require("render-markdown").buf_enable()
            else
              vim.opt_local.conceallevel = 0
              require("render-markdown").buf_disable()
            end
          end)
        end,
      })
    end,
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = "personal", path = vim.env.OBSIDIAN_VAULT_DIR },
      },
      daily_notes = {
        folder = "daily",
      },
    },
    cmd = "Obsidian",
    keys = {
      { "<leader>o", desc = "+Obsidian" },
      {
        "<leader>ot",
        desc = "Obsidian: Today",
        function()
          open_in_scratch(require("obsidian.daily").daily(0))
        end,
      },
      {
        "<leader>oq",
        desc = "Obsidian: Quick Switch",
        function()
          Obsidian.picker.find_files(Obsidian.picker, { callback = open_in_scratch })
        end,
      },
      {
        "<leader>or",
        desc = "Obsidian: Recent files",
        function()
          require("plugins.obsidian.picker").list_recent_files(open_in_scratch)
        end,
      },
      {
        "<leader>og",
        desc = "Obsidian: Grep",
        function()
          Obsidian.picker.grep_notes(Obsidian.picker, { callback = open_in_scratch })
        end,
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter", "nvim-web-devicons" },
    lazy = true,
    ---@type render.md.UserConfig
    opts = {
      completions = { blink = { enabled = true } },
    },
  },
}
