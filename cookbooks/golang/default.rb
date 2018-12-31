package 'go'

# FIXME
gopath = ENV['HOME']
gobin = "#{ENV['HOME']}/gobin"

execute 'install dep' do
  command "curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh"
  not_if 'test $(which dep)'
end

define 'go_get', build: true do
  pkg = params[:name]
  execute "get #{pkg}" do
    command "GOPATH=#{gopath} go get -u #{params[:build] ? "" : "-d"} #{pkg}"
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
      command "GOPATH=#{gopath} go build -o #{gobin}/#{bin} #{pkg}"
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
go_bin 'github.com/arl/gitstatus/cmd/gitstatus'

# for vim
go_bin 'golang.org/x/tools/cmd/godoc'
go_bin 'golang.org/x/tools/cmd/goimports'
go_bin 'golang.org/x/tools/cmd/guru'

# liters: https://github.com/alecthomas/gometalinter#supported-linters
go_bin 'gopkg.in/alecthomas/gometalinter.v2' do
  bin "gometalinter"
end
go_bin 'golang.org/x/tools/cmd/gotype'
go_bin 'github.com/fzipp/gocyclo'
go_bin 'github.com/golang/lint/golint'
go_bin 'github.com/kisielk/errcheck'
go_bin 'mvdan.cc/interfacer'
go_bin 'github.com/mdempsky/unconvert'
go_bin 'github.com/jgautheron/goconst/cmd/goconst'
go_bin 'github.com/GoASTScanner/gas/cmd/gas'
