git anyenv_root do
  repository 'https://github.com/riywo/anyenv'
  revision '3cb8ad1b0dfd89ed5a53fcc9e076b371f6baabfc'
end

define :install_env do
  execute "Install #{params[:name]}" do
    command with_anyenv("yes | anyenv install #{params[:name]}")
    not_if "test -e #{anyenv_root}/envs/#{params[:name]}"
  end
end

define :install_env_version, version: nil do
  cmd = "#{params[:name]} install #{params[:version]}"
  execute cmd do
    command with_anyenv(cmd)
    not_if with_anyenv("#{params[:name]} versions | grep '#{params[:version]}'")
  end
end

define :install_env_versions, versions: [] do
  params[:versions].each do |v|
    install_env_version params[:name] do
      version v
    end
  end
end

define :env_global, version: nil do
  vers = []
  if params[:version].is_a? Array
    vers = params[:version]
    ver = vers.join(" ")
  else
    ver = params[:version]
    vers = [ver]
  end

  cmd = "#{params[:name]} global #{ver} && #{params[:name]} rehash"
  check_cmd = vers.map { |v| "#{params[:name]} global | grep '#{v}'" }.join(" && ")

  execute cmd do
    command with_anyenv(cmd)
    not_if with_anyenv(check_cmd)
  end
end
