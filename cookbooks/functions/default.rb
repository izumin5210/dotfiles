define :dotfile, source: nil do
  source = params[:source] || params[:name]
  source_path = File.expand_path("../../../config/#{source}", __FILE__)

  fail "#{source_path} does not exist" unless File.exist? source_path

  should_force = codespaces?

  target = File.join(node[:home], params[:name])
  directory File.dirname(target)
  link target do
    to source_path
    force should_force
    user node[:user]
  end
end

define :dotfile_template, source: nil, variables: {} do
  template File.join(node[:home], params[:name]) do
    action :create
    source params[:source]
    variables params[:variables].merge(platform: node[:platform])
    user node[:user]
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
  execute "brew install --cask #{caskname}" do
    not_if "ls -1 /usr/local/Caskroom/ | grep '#{caskname}'"
  end
end

define :github_release, repo: nil, version: nil, archive: nil, checksum: nil, bin: nil, prefix: nil do
  bin_dir = "#{params[:prefix] || default_prefix}/bin"
  bin = "#{bin_dir}/#{params[:name]}"
  url = "https://github.com/#{params[:repo]}/releases/download/#{params[:version]}"

  execute "curl -sfL -o /tmp/#{params[:archive]} #{url}/#{params[:archive]}" do
    not_if "test -f #{bin}"
  end

  if params[:checksum]
    execute "curl -sfL -o /tmp/#{params[:checksum]} #{url}/#{params[:checksum]}" do
      not_if "test -f #{bin}"
    end
    execute "sha256sum -c #{params[:checksum]} --ignore-missing" do
      not_if "test -f #{bin}"
      cwd "/tmp"
    end
  end

  execute 'unarchive' do
    case params[:archive]
    when /.zip$/; command "unzip -o /tmp/#{params[:archive]}"
    when /.tar.gz$/; command "tar -xf /tmp/#{params[:archive]}"
    end
    not_if "test -f #{bin}"
    cwd '/tmp'
  end

  directory bin_dir do
    user node[:user]
  end

  execute "mv /tmp/#{params[:bin] || params[:name]} #{bin} && chmod +x #{bin}" do
    not_if "test -f #{bin}"
    user node[:user]
  end
end
