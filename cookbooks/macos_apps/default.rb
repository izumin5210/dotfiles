cask '1password'
cask 'adobe-creative-cloud'
cask 'alfred'
cask 'android-file-transfer'
cask 'appcleaner'
cask 'arduino'
cask 'bettertouchtool'
cask 'contexts'
cask 'dash'
cask 'day-o'
cask 'dropbox'
cask 'firefox'
cask 'google-chrome'
cask 'google-drive'
cask 'google-japanese-ime'
cask 'gyazo'
cask 'insomnia'
cask 'iterm2'
cask 'jasper'
cask 'jetbrains-toolbox'
cask 'licecap'
cask 'postico'
cask 'skitch'
cask 'skype'
cask 'the-unarchiver'
cask 'visual-studio-code'
cask 'zeplin'

package 'mas'

define :mas, id: nil do
  execute "Install #{params[:name]}" do
    command "mas install #{params[:id]}"
    not_if "mas list | grep -E '^#{params[:id]} '"
  end
end

execute 'mas signin' do
  not_if 'mas account'
end

[
  { name: 'Display Menu', id: 549083868 },
  { name: 'Keynote', id: 409183694 },
  { name: 'PopClip', id: 445189367 },
  { name: 'Slack', id: 803453959 },
  { name: 'Wantedly Chat', id: 1076860635 },
  { name: 'Xcode', id: 497799835 },
].each do |app|
  mas app[:name] do
    id app[:id]
  end
end
