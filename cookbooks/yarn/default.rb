yarn_version = node[:yarn][:version]
yarn_root = "#{ENV['HOME']}/.yarn"

execute 'Install yarn' do
  command "nodenv init; curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version #{yarn_version}"
  not_if "test -e #{yarn_root} && #{yarn_root}/bin/yarn --version | grep #{yarn_version}"
end
