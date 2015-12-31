require 'serverspec'
require 'docker'

set :backend, :docker
set :docker_url, ENV['DOCKER_HOST']
set :docker_image, 'izumin5210/dotfiles'
