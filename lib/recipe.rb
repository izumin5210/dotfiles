include_recipe 'recipe_helper'

Dir.glob(File.join(root_dir, 'nodes', '**', '*.{yml,yaml,json}')).each do |path|
  include_node path
end

node.reverse_merge!(
  user: ENV['SUDO_USER'] || ENV['USER'],
)

include_role node[:platform]
