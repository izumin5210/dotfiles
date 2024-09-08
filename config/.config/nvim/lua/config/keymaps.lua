vim.g.mapleader = " "

-- search
vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR><Esc>", { noremap = true, desc = "Search: Clear Search Highlight" })
-- center search results
vim.keymap.set("n", "n", "nzz", { noremap = true, desc = "Search: Next" })
vim.keymap.set("n", "N", "Nzz", { noremap = true, desc = "Search: Prev" })
vim.keymap.set("n", "*", "*zz", { noremap = true, desc = "Search: Next" })
vim.keymap.set("n", "#", "#zz", { noremap = true, desc = "Search: Prev" })
vim.keymap.set("n", "g*", "g*zz", { noremap = true, desc = "Search: Next" })
vim.keymap.set("n", "g#", "g#zz", { noremap = true, desc = "Search: Prev" })

-- buffers
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Buffer: Prev" })
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true, desc = "Buffer: Next" })
vim.keymap.set("n", "[b", ":bprevious<CR>", { noremap = true, silent = true, desc = "Buffer: Prev" })
vim.keymap.set("n", "]b", ":bnext<CR>", { noremap = true, silent = true, desc = "Buffer: Next" })
-- <C-q> to delete buffer using bufdelete.nvim

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
  vim.keymap.set("n", "<leader>rn", function()
    require("vscode-neovim").call("editor.action.rename")
  end, { noremap = true, desc = "Rename Symbol" })
  vim.keymap.set("n", "<leader>q", function()
    require("vscode-neovim").call("workbench.actions.view.problems")
  end, { noremap = true, desc = "Show Diagnostics list" })
end
