if node[:platform] == 'darwin'
  brew_tap 'homebrew/cask-fonts'

  cask 'font-fontawesome'
  cask 'font-inconsolata'
  cask 'font-noto-sans-cjk-jp'
  cask 'font-poppins'
  cask 'font-hackgen-nerd'
end
