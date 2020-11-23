package 'tmux'
package 'reattach-to-user-namespace' if node[:platform] == 'darwin'

plugins_dir = "#{node[:home]}/.tmux/plugins"

git "#{plugins_dir}/tpm" do
  repository 'https://github.com/tmux-plugins/tpm'
  revision 'c8ac32a085d382c43190bda4fb5972e531f501fd'
  user node[:user]
end

execute "#{plugins_dir}/tpm/bin/install_plugins" do
  subscribes :run, "link[#{node[:home]}/.tmux.conf]"
  action :nothing
  user node[:user]
end

dotfile '.tmux.conf'
dotfile '.gitmux.yml'
