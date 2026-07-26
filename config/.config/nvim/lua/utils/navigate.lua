local M = {}

--- 外側のマルチプレクサとペイン移動を共有するための橋渡し。
---
--- nvim の分割移動を先に試し、端で動けなかったときだけマルチプレクサ側へ抜ける。
--- 判定は nvim-tmux-navigation と同じく winnr の変化で行う。
--- herdr の中で tmux を動かすことがある (herdr の allow_nested) ため、内側の tmux を先に見る。

local directions = {
  h = { tmux = "Left", herdr = "left" },
  j = { tmux = "Down", herdr = "down" },
  k = { tmux = "Up", herdr = "up" },
  l = { tmux = "Right", herdr = "right" },
}

local function herdr_bin()
  local bin = vim.env.HERDR_BIN_PATH
  if bin == nil or bin == "" then
    return "herdr"
  end
  return bin
end

---@param args string[]
---@return table|nil
local function herdr_json(args)
  local out = vim.fn.system(vim.list_extend({ herdr_bin() }, args))
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local ok, decoded = pcall(vim.json.decode, out)
  if not ok then
    return nil
  end
  return decoded
end

--- nvim-tmux-navigation の disable_when_zoomed = true に合わせ、zoom 中は nvim の外へ出さない。
--- layout.zoomed は tmux の #{window_zoomed_flag} と同じタブ単位のフラグ。
--- herdr は zoom 中でも pane focus を拒否しない (PaneFocusDirectionReason は no_neighbor のみ) ので、
--- ここで明示的に止める必要がある。プラグインと違い毎キーではなく端に達したときだけ問い合わせる。
---@param pane string
---@return boolean
local function herdr_zoomed(pane)
  local res = herdr_json({ "pane", "layout", "--pane", pane })
  return res ~= nil and res.result ~= nil and res.result.layout ~= nil and res.result.layout.zoomed == true
end

---@param key "h"|"j"|"k"|"l"
function M.navigate(key)
  local dir = directions[key]

  if vim.env.TMUX then
    return require("nvim-tmux-navigation")["NvimTmuxNavigate" .. dir.tmux]()
  end

  local winnr = vim.fn.winnr()
  pcall(vim.cmd, "wincmd " .. key)
  if winnr ~= vim.fn.winnr() then
    return
  end

  -- HERDR_PANE_ID は herdr が各ペインに注入する。素のターミナルでは単なる wincmd で終わる。
  local pane = vim.env.HERDR_PANE_ID
  if pane == nil or pane == "" or herdr_zoomed(pane) then
    return
  end
  vim.fn.system({ herdr_bin(), "pane", "focus", "--direction", dir.herdr, "--pane", pane })
end

return M
