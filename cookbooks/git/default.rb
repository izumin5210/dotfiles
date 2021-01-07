package 'git' do
  if node[:platform] == 'darwin'
    options '--with-pcre'
  end
end

if node[:platform] == 'darwin'
  package 'gh'
else
  github_release 'gh' do
    v = "1.2.1"
    name = "gh_#{v}_#{node[:kernel][:name].downcase}_amd64"

    repo 'cli/cli'
    version "v#{v}"
    archive "#{name}.tar.gz"
    checksum "gh_#{v}_checksums.txt"
    bin "#{name}/bin/gh"
  end
end

if node[:platform] == 'darwin'
  link "/usr/local/bin/diff-highlight" do
    to "/usr/local/share/git-core/contrib/diff-highlight/diff-highlight"
  end
end

if codespaces?
  bin = '/usr/share/doc/git/contrib/diff-highlight/diff-highlight'

  execute "chmod +x #{bin}"
  link "#{default_prefix}/bin/diff-highlight" do
    to bin
  end
end

dotfile '.gitconfig'
dotfile '.gitignore_global'
dotfile '.git_template'
dotfile_template '.gitconfig.local' do
  source File.expand_path('../templates/gitconfig_local.erb', __FILE__)
end
