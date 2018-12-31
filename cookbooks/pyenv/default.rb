include_cookbook 'anyenv'

pyenv_root = "#{ENV['HOME']}/.pyenv"

package 'pyenv'

directory "#{pyenv_root}/plugins" do
  action :create
end

git "#{pyenv_root}/plugins/pyenv-default-packages" do
  repository 'https://github.com/jawshooah/pyenv-default-packages'
  revision 'fb6f71a0288b5aec5723b6118aa0ca02e2cc9a23'
end

file "#{pyenv_root}/default-packages" do
  content "#{(node.dig(:pyenv, :'default-packages') || []).join("\n")}\n"
end

install_env_versions 'pyenv' do
  versions node.dig(:pyenv, :versions)
end

env_global 'pyenv' do
  version node.dig(:pyenv, :global)
end
