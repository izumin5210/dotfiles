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
  cmd = "#{params[:name]} global #{params[:version]} && #{params[:name]} rehash"
  execute cmd do
    command with_anyenv(cmd)
    not_if with_anyenv("#{params[:name]} global | grep '#{params[:version]}'")
  end
end
