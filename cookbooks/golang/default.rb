package 'go'

# FIXME
gopath = ENV['HOME']
gobin = "#{ENV['HOME']}/gobin"

directory gobin do
  action :create
end

define 'go_get', build: true do
  pkg = params[:name]
  execute "get #{pkg}" do
    command "GOPATH=#{gopath} GOBIN=#{gobin} go install #{pkg}@latest"
    not_if "test -e #{gopath}/src/#{pkg}"
  end
end

define 'go_bin' do
  pkg = params[:name]
  go_get pkg
end

# tools
go_bin 'github.com/go-delve/delve/cmd/dlv'
# go_bin 'github.com/x-motemen/gore'
# go_bin 'github.com/pwaller/goimports-update-ignore'
# go_bin 'github.com/rakyll/hey'
go_bin 'github.com/rakyll/gotest'

# for vim
go_bin 'golang.org/x/tools/cmd/godoc'
go_bin 'golang.org/x/tools/cmd/goimports'
go_bin 'golang.org/x/tools/cmd/guru'
go_bin 'golang.org/x/tools/gopls'

golangcilint_version = "v1.47.2"

execute 'install golangci-lint' do
  command "curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b #{gobin} #{golangcilint_version}"
  not_if 'test $(which golangci-lint)'
end
