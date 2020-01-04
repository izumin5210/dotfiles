package 'neovim'

if node[:platform] == 'darwin'
  package 'macvim' do
    options '--with-lua --with-python3' if node[:platform] == 'darwin'
  end

  package 'neovim' do
    options '--HEAD'
  end
end

dotfile '.vimrc'
dotfile '.vim'
dotfile '.config/nvim'
dotfile '.ideavimrc'

vim_plug_version = '0.10.0'

vim_plug_path = "#{ENV['HOME']}/.vim/autoload/plug.vim"
directory File.dirname(vim_plug_path)
http_request vim_plug_path do
  url "https://raw.githubusercontent.com/junegunn/vim-plug/#{vim_plug_version}/plug.vim"
end

nvim_plug_path = "#{ENV['HOME']}/.local/share/nvim/site/autoload/plug.vim"
directory File.dirname(nvim_plug_path)
link nvim_plug_path do
  to vim_plug_path
end
