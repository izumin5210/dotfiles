hostname = `hostname -s`.chomp
is_lx = hostname == 'CM2NX3M6CH'

cask "1password"
cask "1password-cli"
cask "alfred"
cask "arc"
cask "bettertouchtool"
cask "contexts"
cask "dash"
cask "deepl"
cask "dropbox"
cask "karabiner-elements"
cask "ngrok"
cask "obsidian"
cask "spotify"
cask "visual-studio-code"
mas "Kindle", id: 302584613
mas "PopClip", id: 445189367

if !is_lx
  cask "google-chrome"
  cask "google-japanese-ime"
end

if is_lx
  mas "Twingate", id: 1501592214
end