rbenv_root = "#{anyenv_root}/envs/rbenv"

execute 'Install rbenv' do
  command with_anyenv("yes | anyenv install rbenv")
  not_if "test -e #{rbenv_root}"
end

git "#{rbenv_root}/plugins/rbenv-default-gems" do
  repository 'https://github.com/sstephenson/rbenv-default-gems'
  revision 'de4ff2e101c9221dcd92ed91a41edcea2be41945'
end

default_gems = node.dig(:rbenv, :'default-gems')
if default_gems.is_a? Array
  file "#{rbenv_root}/default-gems" do
    content default_gems.join("\n")
  end
end

versions = node.dig(:rbenv, :versions)
if versions.is_a? Array
  versions.each do |version|
    cmd = "rbenv install #{version}"
    execute cmd do
      command with_anyenv(cmd)
      not_if with_anyenv("rbenv versions | grep '#{version}'")
    end
  end
end

global = node.dig(:rbenv, :global)
if global.is_a? String
  cmd = "rbenv global #{global}"
  execute cmd do
    command with_anyenv(cmd)
    not_if with_anyenv("rbenv global | grep '#{global}'")
  end
end
