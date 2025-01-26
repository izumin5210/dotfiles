hostname = `hostname -s`.chomp
is_lx = hostname == 'CM2NX3M6CH'

cask "1password"
cask "alacritty"
cask "arc"
cask "bettertouchtool"
cask "contexts"
cask "dash"
cask "deepl"
cask "dropbox"
cask "hammerspoon"
cask "karabiner-elements"
cask "obsidian"
cask "raycast"
cask "spotify"
cask "tableplus"
cask "visual-studio-code"
mas "Kindle", id: 302584613
mas "PopClip", id: 445189367

if !is_lx
  cask "google-chrome"
  cask "google-japanese-ime"
  cask "orbstack"
  mas "Slack for Desktop", id: 803453959
end

if is_lx
  cask "rancher"
  mas "Twingate", id: 1501592214
end
