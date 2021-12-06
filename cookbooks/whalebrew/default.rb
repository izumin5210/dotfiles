bin = "#{brew_prefix}/bin/whalebrew"
ver = '0.1.0'

execute 'Install whalebrew' do
  command "curl -L \"https://github.com/bfirsh/whalebrew/releases/download/#{ver}/whalebrew-$(uname -s)-$(uname -m)\" -o #{bin}; chmod +x #{bin}"
  not_if "test -e #{bin}"
end
