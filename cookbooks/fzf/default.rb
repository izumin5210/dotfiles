if node[:platform] == 'darwin'
  package 'fzf'
else
  github_release 'fzf' do
    repo 'junegunn/fzf'
    version '0.24.3'
    archive 'fzf-0.24.3-linux_amd64.tar.gz'
  end

  prefix = "#{default_prefix}/opt"

  directory prefix do
    action :create
  end

  git "#{prefix}/fzf" do
    repository 'https://github.com/junegunn/fzf'
    revision '0.24.3'
  end
end
