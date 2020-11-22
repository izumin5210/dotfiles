define :dotfile, source: nil do
  source = params[:source] || params[:name]
  source_path = File.expand_path("../../../config/#{source}", __FILE__)

  fail "#{source_path} does not exist" unless File.exist? source_path

  target = File.join(ENV['HOME'], params[:name])
  directory File.dirname(target)

  link target do
    to source_path
    user node[:user]
  end
end

define :dotfile_template, source: nil, variables: {} do
  template File.join(ENV['HOME'], params[:name]) do
    action :create
    source params[:source]
    variables params[:variables].merge(platform: node[:platform])
  end
end

define :brew_tap do
  tapname = params[:name]
  user, repo = tapname.split('/')
  execute "brew tap #{tapname}" do
    not_if "test -e /usr/local/Homebrew/Library/Taps/#{user}/homebrew-#{repo}"
  end
end

define :cask do
  caskname = params[:name]
  execute "brew cask install #{caskname}" do
    not_if "ls -1 /usr/local/Caskroom/ | grep '#{caskname}'"
  end
end

define :github_release, repo: nil, version: nil, archive: nil, bin: nil, prefix: '/usr/local/bin' do
  bin = "#{params[:prefix]}/#{params[:name]}"
  url = "https://github.com/#{params[:repo]}/releases/download/#{params[:version]}/#{params[:archive]}"

  execute "curl -sfL -o /tmp/#{params[:archive]} #{url}" do
    not_if "test -f #{bin}"
  end

  execute 'unarchive' do
    case params[:archive]
    when /.zip$/; command "unzip -o /tmp/#{params[:archive]}"
    when /.tar.gz$/; command "tar -xf /tmp/#{params[:archive]}"
    end
    not_if "test -f #{bin}"
    cwd '/tmp'
  end

  execute "mv /tmp/#{params[:bin] || params[:name]} #{bin} && chmod +x #{bin}" do
    not_if "test -f #{bin}"
  end
end
