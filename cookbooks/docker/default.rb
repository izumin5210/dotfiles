if node[:platform] == 'darwin'
  package 'docker'
  cask 'docker'
  cask 'docker-toolbox'
end
