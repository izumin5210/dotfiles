if node[:platform] == 'darwin'
  brew_tap 'homebrew/cask-fonts'

  cask 'font-fontawesome'
  cask 'font-inconsolata'
  cask 'font-noto-sans-cjk-jp'
  cask 'font-poppins'

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

  execute 'Install Cica' do
    v = 'v4.1.2'
    command <<EOC
curl -L -s -O https://github.com/miiton/Cica/releases/download/#{v}/Cica_#{v}.zip
unzip Cica_#{v}.zip -d Cica_#{v}
cp -f Cica_#{v}/*.ttf ~/Library/Fonts/
rm -rf Cica_#{v}*
EOC
    not_if 'ls -1 ~/Library/Fonts/ | grep -c -E "Cica-.*\.ttf$" | grep -E "^4$"'
  end
end
