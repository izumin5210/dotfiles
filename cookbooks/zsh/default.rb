package 'zsh'
package 'zsh-completions'

dotfile '.zshenv'
dotfile '.zshrc'
dotfile '.zsh'

if node[:platform] == 'darwin'
  zsh_path = '/usr/local/bin/zsh'

  execute "'echo '#{zsh_path}' >> /etc/shells" do
    not_if "cat /etc/shells | grep -q '#{zsh_path}'"
  end

  execute "chsh -s #{zsh_path}" do
    not_if "dscl localhost -read Local/Default/Users/#{node[:user]} UserShell | grep -q '#{zsh_path}'"
  end
end
