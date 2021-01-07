if node[:platform] == 'darwin'
  package 'ripgrep'
else
  github_release 'ripgrep' do
    repo 'BurntSushi/ripgrep'
    version '12.1.1'
    archive 'ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz'
    bin 'ripgrep-12.1.1-x86_64-unknown-linux-musl.tar.gz/rg'
  end
end

dotfile '.ripgreprc'
