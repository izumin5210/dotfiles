vim.g.mapleader = " "

-- Edit
----------------------------------------------------------------
-- keep cursor position on visual copy
-- https://zenn.dev/vim_jp/articles/43d021f461f3a4#visual-%E3%82%B3%E3%83%94%E3%83%BC%E6%99%82%E3%81%AB%E3%82%AB%E3%83%BC%E3%82%BD%E3%83%AB%E4%BD%8D%E7%BD%AE%E3%82%92%E4%BF%9D%E5%AD%98
vim.keymap.set("x", "y", "mzy`z", { noremap = true })
-- do not change register on visual paste
-- https://zenn.dev/vim_jp/articles/43d021f461f3a4#visual-%E3%83%9A%E3%83%BC%E3%82%B9%E3%83%88%E6%99%82%E3%81%AB%E3%83%AC%E3%82%B8%E3%82%B9%E3%82%BF%E3%81%AE%E5%A4%89%E6%9B%B4%E3%82%92%E9%98%B2%E6%AD%A2
vim.keymap.set("x", "p", "P", { noremap = true })
-- keep visual selection after indenting
-- https://zenn.dev/vim_jp/articles/43d021f461f3a4#visual-%3C%2C-%3E%E3%81%A7%E9%80%A3%E7%B6%9A%E3%81%97%E3%81%A6%E3%82%A4%E3%83%B3%E3%83%87%E3%83%B3%E3%83%88%E3%82%92%E6%93%8D%E4%BD%9C
vim.keymap.set("x", "<", "<gv", { noremap = true })
vim.keymap.set("x", ">", ">gv", { noremap = true })
-- indent after paste and move cursor at the end of the pasted text
-- https://zenn.dev/vim_jp/articles/43d021f461f3a4#%E3%83%9A%E3%83%BC%E3%82%B9%E3%83%88%E7%B5%90%E6%9E%9C%E3%81%AE%E3%82%A4%E3%83%B3%E3%83%87%E3%83%B3%E3%83%88%E3%82%92%E8%87%AA%E5%8B%95%E3%81%A7%E6%8F%83%E3%81%88%E3%82%8B
vim.keymap.set("n", "p", "]p`]", { noremap = true })
vim.keymap.set("n", "P", "]P`]", { noremap = true })
-- jump to the next or prev blank line
-- https://zenn.dev/vim_jp/articles/43d021f461f3a4#%E7%9B%B4%E5%89%8D%E3%83%BB%E7%9B%B4%E5%BE%8C%E3%81%AE%E7%A9%BA%E8%A1%8C%E3%81%AB%E9%A3%9B%E3%81%B6
vim.keymap.set("n", "F<cr>", "{", { noremap = true })
vim.keymap.set("n", "f<cr>", "}", { noremap = true })
-- Move lines up and down
-- https://zenn.dev/vim_jp/articles/43d021f461f3a4#%E8%A1%8C%E3%82%92%E4%B8%8A%E4%B8%8B%E3%81%AB%E7%A7%BB%E5%8B%95
vim.keymap.set("x", "<C-k>", ":move'<-2<CR>gv=gv", { noremap = true, desc = "Move line up" })
vim.keymap.set("x", "<C-j>", ":move'>+1<CR>gv=gv", { noremap = true, desc = "Move line down" })

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

vim.keymap.set("n", "<CR>", function()
  if vim.fn.foldclosed(".") ~= -1 then
    return "zo"
  else
    return "<CR>"
  end
end, { expr = true, noremap = true })

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
