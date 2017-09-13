package 'vim' do
  options '--with-lua' if node[:platform] == 'darwin'
end

if node[:platform] == 'darwin'
  package 'macvim' do
    options '--with-lua --with-python3' if node[:platform] == 'darwin'
  end

  package 'neovim/neovim/neovim' do
    options '--HEAD'
  end
  cask "vimr"
end

dotfile '.vimrc'
dotfile '.vim'
dotfile '.config/nvim'

plugins_dir = "#{ENV['HOME']}/.cache/dein/repos"

git "#{plugins_dir}/github.com/Shougo/dein.vim" do
  repository 'https://github.com/Shougo/dein.vim'
  revision '465cd106365e5b4c89b05d9ed1283ed4f3b70aab'
end
