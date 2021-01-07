execute 'Install Homebrew' do
  command "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\" < /dev/null"
  not_if "test $(which brew)"
end
