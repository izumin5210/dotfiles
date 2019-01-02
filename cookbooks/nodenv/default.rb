include_cookbook 'anyenv'

nodenv_root = "#{ENV['HOME']}/.nodenv"

package 'nodenv'

directory "#{nodenv_root}/plugins" do
  action :create
end

git "#{nodenv_root}/plugins/nodenv-default-packages" do
  repository 'https://github.com/nodenv/nodenv-default-packages'
  revision 'fe9b8ce7fe917a84fb23f5d2efc674005f98ebd9'
end

file "#{nodenv_root}/default-packages" do
  content "#{(node.dig(:nodenv, :'default-packages') || []).join("\n")}\n"
end

install_env_versions 'nodenv' do
  versions node.dig(:nodenv, :versions)
end

env_global 'nodenv' do
  version node.dig(:nodenv, :global)
end

(node.dig(:nodenv, :versions) || []).each do |v|
  (node.dig(:nodenv, :'default-packages') || []).each do |pkg|
    npm = "NODENV_VERSION=#{v} nodenv exec npm"
    execute "Install #{pkg} on Node.js v#{v}" do
      command "#{npm} install -g #{pkg}"
      not_if "#{npm} list -g #{pkg}"
    end
  end
end
