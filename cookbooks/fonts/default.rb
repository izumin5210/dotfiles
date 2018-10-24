if node[:platform] == 'darwin'
  brew_tap 'caskroom/fonts'

  cask 'font-fontawesome'
  cask 'font-inconsolata'
  cask 'font-m-plus'
  cask 'font-noto-sans-cjk-jp'
  cask 'font-poppins'
  cask 'font-raleway'
  cask 'font-raleway-dots'

  brew_tap 'sanemat/font'
  package 'ricty' do
    options '--with-powerline'
  end
  execute 'fc-cache -vf' do
    subscribes :run, 'execute[Copy ricty fonts]'
    action :nothing
  end
  execute 'Copy ricty fonts' do
    command 'cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/'
    not_if 'ls -1 ~/Library/Fonts/ | grep -c -E "Ricty.*\.ttf$" | grep -E "^8$"'
  end
end
