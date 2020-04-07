package 'tmux'
package 'reattach-to-user-namespace' if node[:platform] == 'darwin'

plugins_dir = "#{ENV['HOME']}/.tmux/plugins"

git "#{plugins_dir}/tpm" do
  repository 'https://github.com/tmux-plugins/tpm'
  revision 'c8ac32a085d382c43190bda4fb5972e531f501fd'
end

execute "#{plugins_dir}/tpm/bin/install_plugins" do
  subscribes :run, "link[#{ENV['HOME']}/.tmux.conf]"
  action :nothing
end

dotfile '.tmux.conf'
dotfile '.gitmux.yml'
