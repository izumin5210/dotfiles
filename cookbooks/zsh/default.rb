package 'zsh'

if node[:platform] == 'darwin'
  package 'zsh-completions'
else
  git "#{default_prefix}/share/zsh-completions" do
    repository 'https://github.com/zsh-users/zsh-completions'
    revision '0.32.0'
    user node[:user]
  end
end

dotfile '.zshenv'
dotfile '.zshrc'
dotfile '.zsh'

zsh_path = node[:platform] == 'darwin' ? '/usr/local/bin/zsh' : '$(which zsh)'

execute "echo #{zsh_path} >> /etc/shells" do
  not_if "cat /etc/shells | grep -q #{zsh_path}"
end

execute "chsh -s #{zsh_path}" do
  if node[:platform] == 'darwin'
    not_if "dscl localhost -read Local/Default/Users/#{node[:user]} UserShell | grep -q '#{zsh_path}'"
  end
end
