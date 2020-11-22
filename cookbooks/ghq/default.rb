if node[:platform] == 'darwin'
  package 'ghq'
else
  github_release 'ghq' do
    repo 'x-motemen/ghq'
    version 'v1.1.5'
    archive 'ghq_linux_amd64.zip'
    bin 'ghq_linux_amd64/ghq'
  end
end
