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
}
