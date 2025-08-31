---@param path_or_note obsidian.Note|string
local function open_in_scratch(path_or_note)
  local filename = type(path_or_note) == "string" and path_or_note or path_or_note.path.filename
  require("snacks.scratch").open({
    file = filename,
    ft = "markdown",
    win = {
      width = 0.9,
      height = 0.9,
    },
  })
end

---@param bufnr number
local function enable_conceal_only_in_vault(bufnr)
  local utils = require("plugins.obsidian.utils")
  if not utils.is_md(bufnr) then
    return
  end

  -- enable render-markdown and cnoceallevel only if in Obsidian vaults
  vim.api.nvim_buf_call(bufnr, function()
    vim.opt_local.wrap = true
    vim.opt_local.conceallevel = utils.is_in_vault(bufnr) and 2 or 0
  end)
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = "personal", path = vim.env.OBSIDIAN_VAULT_DIR },
      },
      daily_notes = {
        folder = "daily",
      },
      completion = { nvim_cmp = false, blink = true },
    },
    cmd = "Obsidian",
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
          enable_conceal_only_in_vault(args.buf)
        end,
      })
    end,
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
}
