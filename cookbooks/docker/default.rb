if node[:platform] == 'darwin'
  brew_tap 'caskroom/versions'
  cask 'docker'
  cask 'docker-toolbox'
end
