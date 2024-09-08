-----------------------------------
-- Editor
-----------------------------------
vim.opt.updatetime = 2000

-- edit
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.wrap = false

-- completion
vim.opt.completeopt = "menu,menuone,noselect"

-- show whitespace chars
vim.opt.list = true
vim.opt.listchars = "tab:│─,trail:_,extends:»,precedes:«,nbsp:･"

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true

-- clipboard
if vim.fn.has("unnamedplus") == 1 then
  vim.opt.clipboard = "unnamed,unnamedplus"
else
  vim.opt.clipboard = "unnamed"
end

-- indent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable builtin matchit.vim and matchparen.vim
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- lsp
vim.g.markdown_fenced_languages = {
  "ts=typescript", -- https://github.com/neovim/nvim-lspconfig/blob/e6528f4/doc/server_configurations.md#denols
}

-----------------------------------
-- Appearance
-----------------------------------
vim.opt.termguicolors = true

-- sign
vim.opt.signcolumn = "yes"

-- disable builtin tabline
vim.opt.showtabline = 0

-- hide cmdline
vim.opt.cmdheight = 0

-- clear statusline
vim.opt.laststatus = 0
vim.opt.statusline = string.rep("─", vim.api.nvim_win_get_width(0))
