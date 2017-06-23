if node[:platform] == 'darwin'
  brew_tap 'caskroom/versions'
  cask 'docker-edge'
  cask 'docker-toolbox'
end
