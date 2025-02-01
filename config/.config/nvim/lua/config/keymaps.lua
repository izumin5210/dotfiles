vim.g.mapleader = " "

-- Edit
----------------------------------------------------------------
-- yank to end of line
vim.keymap.set("n", "Y", "y$", { noremap = true, desc = "" })
-- keep cursor position on visual copy
vim.keymap.set("x", "y", "mzy`z", { noremap = true })
-- do not change register on visual paste
vim.keymap.set("x", "p", "P", { noremap = true })
-- keep visual selection after indenting
vim.keymap.set("x", "<", "<gv", { noremap = true })
vim.keymap.set("x", ">", ">gv", { noremap = true })
-- indent after paste and move cursor at the end of the pasted text
vim.keymap.set("n", "p", "]p`]", { noremap = true })
vim.keymap.set("n", "P", "]P`]", { noremap = true })
-- jump to the next or prev blank line
vim.keymap.set("n", "F<cr>", "{", { noremap = true })
vim.keymap.set("n", "f<cr>", "}", { noremap = true })

--- @param n number
local function jump_snip_safe(n)
  local ls = package.loaded["luasnip"]
  if ls and ls.jumpable(n) then
    ls.jump(n)
  end
end

vim.keymap.set({ "i", "s" }, "<C-f>", function()
  jump_snip_safe(1)
end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-b>", function()
  jump_snip_safe(-1)
end, { silent = true })

-- Text objects
----------------------------------------------------------------
-- inner space
vim.keymap.set({ "o", "x" }, "i<space>", "iW", { noremap = true })

-- Search
----------------------------------------------------------------
vim.keymap.set(
  "n",
  "<Esc><Esc>",
  ":nohlsearch<CR><Esc>",
  { noremap = true, silent = true, desc = "Search: Clear Search Highlight" }
)
-- center search results
vim.keymap.set("n", "n", "nzz", { noremap = true, silent = true, desc = "Search: Next" })
vim.keymap.set("n", "N", "Nzz", { noremap = true, silent = true, desc = "Search: Prev" })
vim.keymap.set("n", "*", "*zz", { noremap = true, silent = true, desc = "Search: Next" })
vim.keymap.set("n", "#", "#zz", { noremap = true, silent = true, desc = "Search: Prev" })
vim.keymap.set("n", "g*", "g*zz", { noremap = true, silent = true, desc = "Search: Next" })
vim.keymap.set("n", "g#", "g#zz", { noremap = true, silent = true, desc = "Search: Prev" })

-- Buffers
----------------------------------------------------------------
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Buffer: Prev" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true, desc = "Buffer: Next" })
vim.keymap.set("n", "[b", ":bprevious<CR>", { noremap = true, silent = true, desc = "Buffer: Prev" })
vim.keymap.set("n", "]b", ":bnext<CR>", { noremap = true, silent = true, desc = "Buffer: Next" })
-- <C-q> to delete buffer using bufdelete.nvim

-- VSCode Neovim
----------------------------------------------------------------
if vim.g.vscode then
  vim.keymap.set("n", "gi", function()
    require("vscode-neovim").call("editor.action.goToImplementation")
  end, { noremap = true, desc = "Go to implementation" })
  vim.keymap.set("n", "[d", function()
    require("vscode-neovim").call("editor.action.marker.prev")
  end, { noremap = true, desc = "Go to prev Diagnostic" })
  vim.keymap.set("n", "]d", function()
    require("vscode-neovim").call("editor.action.marker.next")
  end, { noremap = true, desc = "Go to next Diagnostic" })
  vim.keymap.set("n", "[e", function()
    require("vscode-neovim").call("editor.action.marker.prev")
  end, { noremap = true, desc = "Go to prev Diagnostic" })
  vim.keymap.set("n", "]e", function()
    require("vscode-neovim").call("editor.action.marker.next")
  end, { noremap = true, desc = "Go to next Diagnostic" })
  vim.keymap.set("n", "<leader>.", function()
    require("vscode-neovim").call("editor.action.quickFix")
  end, { noremap = true, desc = "Quick fix" })
  vim.keymap.set("n", "<leader>rn", function()
    require("vscode-neovim").call("editor.action.rename")
  end, { noremap = true, desc = "Rename Symbol" })
  vim.keymap.set("n", "<leader>q", function()
    require("vscode-neovim").call("workbench.actions.view.problems")
  end, { noremap = true, desc = "Show Diagnostics list" })
end
