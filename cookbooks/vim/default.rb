package 'neovim'

if node[:platform] == 'darwin'
  package 'macvim' do
    options '--with-lua --with-python3' if node[:platform] == 'darwin'
  end

  package 'neovim/neovim/neovim' do
    options '--HEAD'
  end
end

dotfile '.vimrc'
dotfile '.vim'
dotfile '.config/nvim'

plugins_dir = "#{ENV['HOME']}/.cache/dein/repos"

git "#{plugins_dir}/github.com/Shougo/dein.vim" do
  repository 'https://github.com/Shougo/dein.vim'
  revision 'e5fe114314e9ce8c77f122c148fd6cc4f94f57bf'
end
