package 'go'

# FIXME
gopath = ENV['HOME']
gobin = "#{ENV['HOME']}/gobin"

define 'go_get', bin: false do
  pkg = params[:name]
  cmd = "go get -u #{pkg}"
  execute cmd do
    command "GOPATH=#{gopath} GOBIN=#{gobin} #{cmd}"
    if params[:bin]
      binname = File.basename(pkg)
      not_if "test -e #{gobin}/#{binname}"
    else
      not_if "test -e #{gopath}/src/#{pkg}"
    end
  end
end

define 'go_bin' do
  go_get params[:name] do
    bin true
  end
end

go_bin 'golang.org/x/tools/cmd/godoc'
go_bin 'golang.org/x/tools/cmd/stringer'
go_bin 'golang.org/x/tools/cmd/guru'
go_bin 'golang.org/x/tools/cmd/goimports'
go_bin 'github.com/nsf/gocode'
go_bin 'github.com/motemen/gore'
go_get 'github.com/k0kubun/pp' # for gore
go_bin 'github.com/rogpeppe/godef'
go_bin 'github.com/tpng/gopkgs'
go_bin 'github.com/ramya-rao-a/go-outline'
go_bin 'sourcegraph.com/sqs/goreturns'
go_bin 'github.com/derekparker/delve/cmd/dlv'
go_bin 'github.com/golang/mock/mockgen'
go_bin 'github.com/golang/dep/cmd/dep'
go_bin 'github.com/alecthomas/gometalinter'
go_bin 'github.com/jstemmer/gotags'
go_bin 'github.com/golang/protobuf/protoc-gen-go'

package 'glide'

# liters: https://github.com/alecthomas/gometalinter#supported-linters
go_bin 'golang.org/x/tools/cmd/gotype'
go_bin 'github.com/fzipp/gocyclo'
go_bin 'github.com/golang/lint/golint'
go_bin 'github.com/kisielk/errcheck'
go_bin 'mvdan.cc/interfacer'
go_bin 'github.com/mdempsky/unconvert'
go_bin 'github.com/jgautheron/goconst/cmd/goconst'
go_bin 'github.com/GoASTScanner/gas'
