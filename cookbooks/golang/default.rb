package 'go'

# FIXME
gopath = ENV['HOME']
gobin = "#{ENV['HOME']}/gobin"

define 'go_get' do
  pkg = params[:name]
  cmd = "go get -u #{pkg}"
  execute cmd do
    command "GOPATH=#{gopath} GOBIN=#{gobin} #{cmd}"
    not_if "test -e #{gopath}/src/#{pkg}"
  end
end

go_get 'golang.org/x/tools/cmd/godoc'
go_get 'golang.org/x/tools/cmd/stringer'
go_get 'golang.org/x/tools/cmd/guru'
go_get 'golang.org/x/tools/cmd/goimports'
go_get 'github.com/nsf/gocode'
go_get 'github.com/motemen/gore'
go_get 'github.com/k0kubun/pp'
go_get 'github.com/rogpeppe/godef'
go_get 'github.com/tpng/gopkgs'
go_get 'github.com/ramya-rao-a/go-outline'
go_get 'sourcegraph.com/sqs/goreturns'
go_get 'github.com/derekparker/delve/cmd/dlv'
go_get 'github.com/golang/mock/mockgen'
go_get 'github.com/golang/dep/cmd/dep'
go_get 'github.com/alecthomas/gometalinter'
go_get 'github.com/jstemmer/gotags'

package 'glide'

# liters: https://github.com/alecthomas/gometalinter#supported-linters
go_get 'golang.org/x/tools/cmd/gotype'
go_get 'github.com/fzipp/gocyclo'
go_get 'github.com/golang/lint/golint'
go_get 'github.com/kisielk/errcheck'
go_get 'mvdan.cc/interfacer'
go_get 'github.com/mdempsky/unconvert'
go_get 'github.com/jgautheron/goconst/cmd/goconst'
go_get 'github.com/GoASTScanner/gas'
