include_recipe 'recipe_helper'
include_recipe 'anyenv_helper'

include_node 'rbenv'
include_node 'pyenv'
include_node 'nodenv'
include_node 'macos_defaults'

node.reverse_merge!(
  user: ENV['SUDO_USER'] || ENV['USER'],
)

include_role node[:platform]
