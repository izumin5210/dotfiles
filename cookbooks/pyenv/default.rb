include_cookbook 'anyenv'

pyenv_root = "#{anyenv_root}/envs/pyenv"

install_env 'pyenv'

install_env_versions 'pyenv' do
  versions node.dig(:pyenv, :versions)
end

env_global 'pyenv' do
  version node.dig(:pyenv, :global)
end
