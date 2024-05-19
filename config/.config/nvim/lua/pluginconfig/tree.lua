local M = {}

M.keys = {
  {
    '<C-h>',
    function()
      require('nvim-tree.api').tree.toggle({ find_file = true })
    end,
    desc = 'File: Open Explorer',
    silent = true,
  },
}

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#find-file-from-node-in-telescope
local function launch_telescope(func_name, opts)
  local api = require('nvim-tree.api')
  local openfile = require('nvim-tree.actions.node.open-file')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local view_selection = function(prompt_bufnr, map)
    actions.select_default:replace(function()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      local filename = selection.filename
      if filename == nil then
        filename = selection[1]
      end
      openfile.fn('preview', filename)
    end)
    return true
  end

  local telescope_status_ok, _ = pcall(require, 'telescope')
  if not telescope_status_ok then
    return
  end
  local node = api.tree.get_node_under_cursor()
  local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false
  local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ':h')
  if node.name == '..' and TreeExplorer ~= nil then
    basedir = TreeExplorer.cwd
  end
  opts = opts or {}
  opts.cwd = basedir
  opts.search_dirs = { basedir }
  opts.attach_mappings = view_selection
  return require('telescope.builtin')[func_name](opts)
end

local function launch_live_grep(opts)
  return launch_telescope('live_grep', opts)
end

local function launch_find_files(opts)
  return launch_telescope('find_files', opts)
end

---@return { [1]: keymap_mode, [2]: string, [3]: string | function, desc: string, skip_pallete?: boolean }[]
local function tree_keymaps()
  local api = require('nvim-tree.api')

  return {
    -- default
    -- based on https://github.com/nvim-tree/nvim-tree.lua/blob/3b62c6bf2c3f2973036aed609d02fd0ca9c3af35/lua/nvim-tree/keymap.lua#L31-L83
    { '<C-]>', api.tree.change_root_to_node, desc = 'CD' },
    { '<C-e>', api.node.open.replace_tree_buffer, desc = 'Open: In Place' },
    { '<C-k>', api.node.show_info_popup, desc = 'Info' },
    { '<C-r>', api.fs.rename_sub, desc = 'Rename: Omit Filename' },
    { '<C-t>', api.node.open.tab, desc = 'Open: New Tab' },
    { '<C-v>', api.node.open.vertical, desc = 'Open: Vertical Split' },
    { '<C-x>', api.node.open.horizontal, desc = 'Open: Horizontal Split' },
    { '<BS>', api.node.navigate.parent_close, desc = 'Close Directory' },
    { '<CR>', api.node.open.edit, desc = 'Open' },
    { '<Tab>', api.node.open.preview, desc = 'Open Preview' },
    { '>', api.node.navigate.sibling.next, desc = 'Next Sibling' },
    { '<', api.node.navigate.sibling.prev, desc = 'Previous Sibling' },
    { '.', api.node.run.cmd, desc = 'Run Command' },
    { '-', api.tree.change_root_to_parent, desc = 'Up' },
    { 'a', api.fs.create, desc = 'Create' },
    { 'bd', api.marks.bulk.delete, desc = 'Delete Bookmarked' },
    { 'bmv', api.marks.bulk.move, desc = 'Move Bookmarked' },
    { 'B', api.tree.toggle_no_buffer_filter, desc = 'Toggle Filter: No Buffer' },
    { 'c', api.fs.copy.node, desc = 'Copy' },
    { 'C', api.tree.toggle_git_clean_filter, desc = 'Toggle Filter: Git Clean' },
    { '[c', api.node.navigate.git.prev, desc = 'Prev Git' },
    { ']c', api.node.navigate.git.next, desc = 'Next Git' },
    { 'd', api.fs.remove, desc = 'Delete' },
    { 'D', api.fs.trash, desc = 'Trash' },
    { 'E', api.tree.expand_all, desc = 'Expand All' },
    { 'e', api.fs.rename_basename, desc = 'Rename: Basename' },
    { ']e', api.node.navigate.diagnostics.next, desc = 'Next Diagnostic' },
    { '[e', api.node.navigate.diagnostics.prev, desc = 'Prev Diagnostic' },
    { 'F', api.live_filter.clear, desc = 'Clean Filter' },
    { 'f', api.live_filter.start, desc = 'Filter' },
    { 'g?', api.tree.toggle_help, desc = 'Help' },
    { 'gy', api.fs.copy.absolute_path, desc = 'Copy Absolute Path' },
    { 'H', api.tree.toggle_hidden_filter, desc = 'Toggle Filter: Dotfiles' },
    { 'I', api.tree.toggle_gitignore_filter, desc = 'Toggle Filter: Git Ignore' },
    { 'J', api.node.navigate.sibling.last, desc = 'Last Sibling' },
    { 'K', api.node.navigate.sibling.first, desc = 'First Sibling' },
    { 'm', api.marks.toggle, desc = 'Toggle Bookmark' },
    { 'o', api.node.open.edit, desc = 'Open', skip_pallete = true },
    { 'O', api.node.open.no_window_picker, desc = 'Open: No Window Picker' },
    { 'p', api.fs.paste, desc = 'Paste' },
    { 'P', api.node.navigate.parent, desc = 'Parent Directory' },
    { 'q', api.tree.close, desc = 'Close' },
    { 'r', api.fs.rename, desc = 'Rename' },
    { 'R', api.tree.reload, desc = 'Refresh' },
    { 's', api.node.run.system, desc = 'Run System' },
    { 'S', api.tree.search_node, desc = 'Search' },
    { 'U', api.tree.toggle_custom_filter, desc = 'Toggle Filter: Hidden' },
    { 'W', api.tree.collapse_all, desc = 'Collapse' },
    { 'x', api.fs.cut, desc = 'Cut' },
    { 'y', api.fs.copy.filename, desc = 'Copy Name' },
    { 'Y', api.fs.copy.relative_path, desc = 'Copy Relative Path' },
    { '<2-LeftMouse>', api.node.open.edit, desc = 'Open', skip_pallete = true },
    { '<2-RightMouse>', api.tree.change_root_to_node, desc = 'CD', skip_pallete = true },
    -- custom
    { '<Esc>', api.tree.close, desc = 'Close', skip_pallete = true },
    { '<c-f>', launch_find_files, desc = 'Launch Find Files' },
    { '<c-g>', launch_live_grep, desc = 'Launch Live Grep' },
  }
end

-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Recipes#creating-an-actions-menu-using-telescope
local function tree_actions_menu(node)
  local entry_maker = function(menu_item)
    return {
      value = menu_item,
      ordinal = menu_item.name,
      display = menu_item.name,
    }
  end

  local tree_actions = {}
  for _, km in pairs(tree_keymaps()) do
    if km.skip_pallete ~= true then
      table.insert(tree_actions, { name = km.desc, handler = km[2] })
    end
  end

  local finder = require('telescope.finders').new_table({
    results = tree_actions,
    entry_maker = entry_maker,
  })

  local sorter = require('telescope.sorters').get_generic_fuzzy_sorter()

  local default_options = {
    finder = finder,
    sorter = sorter,
    attach_mappings = function(prompt_buffer_number)
      local actions = require('telescope.actions')

      -- On item select
      actions.select_default:replace(function()
        local state = require('telescope.actions.state')
        local selection = state.get_selected_entry()
        -- Closing the picker
        actions.close(prompt_buffer_number)
        -- Executing the callback
        selection.value.handler(node)
      end)

      -- The following actions are disabled in this example
      -- You may want to map them too depending on your needs though
      actions.add_selection:replace(function() end)
      actions.remove_selection:replace(function() end)
      actions.toggle_selection:replace(function() end)
      actions.select_all:replace(function() end)
      actions.drop_all:replace(function() end)
      actions.toggle_all:replace(function() end)

      return true
    end,
  }

  -- Opening the menu
  require('telescope.pickers')
    .new({ prompt_title = 'Tree menu', layout_config = { width = 0.3, height = 0.5 } }, default_options)
    :find()
end

function M.setup()
  require('nvim-tree').setup({
    renderer = {
      highlight_opened_files = 'all',
      special_files = {},
    },
    live_filter = {
      always_show_folders = false,
    },
    filters = {
      custom = { '.git' },
    },
    on_attach = function(bufnr)
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      for _, km in pairs(tree_keymaps()) do
        vim.keymap.set('n', km[1], km[2], opts(km.desc))
      end

      vim.keymap.set('n', '<Space>', tree_actions_menu, opts('Command Pallete'))
    end,
  })
end

return M
