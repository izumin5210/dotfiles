define :dotfile, source: nil do
  source = params[:source] || params[:name]
  source_path = File.expand_path("../../../config/#{source}", __FILE__)

  fail "#{source_path} does not exist" unless File.exist? source_path

  link File.join(ENV['HOME'], params[:name]) do
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
