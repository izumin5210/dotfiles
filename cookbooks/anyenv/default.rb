define :install_env_version, version: nil do
  cmd = "#{params[:name]} install #{params[:version]}"
  execute cmd do
    command cmd
    not_if "#{params[:name]} versions --bare | grep '^#{params[:version]}$'"
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
    command cmd
    not_if check_cmd
  end
end
