brew_tap 'homebrew/cask-versions'

node[:macos_apps][:cask].each do |app|
  cask app
end

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

node[:macos_apps][:mas].each do |app|
  mas app[:name] do
    id app[:id]
  end
end
