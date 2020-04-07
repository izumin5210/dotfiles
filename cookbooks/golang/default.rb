package 'go'

# FIXME
gopath = ENV['HOME']
gobin = "#{ENV['HOME']}/gobin"

directory gobin do
  action :create
end

execute 'install dep' do
  command "curl https://raw.githubusercontent.com/golang/dep/master/install.sh | GOBIN=#{gobin} sh"
  not_if 'test $(which dep)'
end

define 'go_get', build: true do
  pkg = params[:name]
  execute "get #{pkg}" do
    command "GOPATH=#{gopath} GOBIN=#{gobin} go get -u #{params[:build] ? "" : "-d"} #{pkg}"
    not_if "test -e #{gopath}/src/#{pkg}"
  end
end

define 'go_bin', bin: nil do
  pkg = params[:name]
  bin = params[:bin]
  if bin
    go_get pkg do
      build false
    end
    execute "build #{pkg}" do
      command "GOPATH=#{gopath} GOBIN=#{gobin} go build -o #{gobin}/#{bin} #{pkg}"
    end
  else
    go_get pkg
  end
end

# tools
go_bin 'github.com/derekparker/delve/cmd/dlv'
go_bin 'github.com/motemen/gore'
go_bin 'github.com/pwaller/goimports-update-ignore'
go_bin 'github.com/rakyll/hey'

# tmux
go_bin 'github.com/arl/gitmux'

# for vim
go_bin 'golang.org/x/tools/cmd/godoc'
go_bin 'golang.org/x/tools/cmd/goimports'
go_bin 'golang.org/x/tools/cmd/guru'
go_bin 'golang.org/x/tools/cmd/gopls'

golangcilint_version = "v1.22.2"

execute 'install golangci-lint' do
  command "curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b #{gobin} #{golangcilint_version}"
  not_if 'test $(whichi golangci-lint)'
end
