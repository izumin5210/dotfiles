execute 'Install Homebrew' do
  command "/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\" < /dev/null"
  not_if "test $(which brew)"
end
