package 'git' do
  if node[:platform] == 'darwin'
    options '--with-pcre'
  end
end

github_release 'gh' do
  v = "1.2.1"
  name = "gh_#{v}_#{node[:kernel][:name].downcase}_amd64"

  repo 'cli/cli'
  version "v#{v}"
  archive "#{name}.tar.gz"
  checksum "gh_#{v}_checksums.txt"
  bin "#{name}/bin/gh"
end

dotfile '.gitconfig'
dotfile '.gitcommit-template'
dotfile '.gitignore_global'
dotfile '.git_template'
dotfile_template '.gitconfig.local' do
  source File.expand_path('../templates/gitconfig_local.erb', __FILE__)
end
