MItamae::RecipeContext.class_eval do
  def include_cookbook(name)
    include_recipe File.join(root_dir, 'cookbooks', name, 'default')
  end

  def include_role(name)
    include_recipe File.join(root_dir, 'roles', name, 'default')
  end

  def codespaces?
    ENV['CODESPACES'] == 'true'
  end

  def root_dir
    @root_dir ||= File.expand_path('../..', __FILE__)
  end

  def brew_prefix
    arch = `uname -m`.chomp
    case arch
    when 'x86_64'; '/usr/local'
    when 'arm64';  '/opt/homebrew'
    else fail "unknown arch: #{arch}"
    end
  end

  def default_prefix
    "#{home_dir}/.local"
  end

  def default_bin_dir
    "#{default_prefix}/bin"
  end

  def default_tmp_dir
    "#{home_dir}/.tmp"
  end

  def default_user
    ENV['SUDO_USER'] || ENV['USER']
  end

  def home_dir
    File.expand_path("~#{default_user}")
  end

  def include_node(path)
    raw = File.read(path)
    content =
      case File.extname(path)
      when '.yml', '.yaml' then YAML.load(raw)
      when '.json' then JSON.parse(raw)
      end

    node.reverse_merge!(content)
  end

  def type_from_value value
    case value
    when String      then 'string'
    # when ???       then 'data'
    when Integer     then 'int'
    when Float       then 'float'
    when TrueClass   then 'bool'
    when FalseClass  then 'bool'
    # when ???       then 'date'
    when Array       then 'array'
    # when ???       then 'array-add'
    # when ???       then 'dict'
    # when ???       then 'dict-add'
    else
      fail "Unexpected type: #{value} (#{value.class})"
    end
  end

  def execute_macos_defaults(defaults, domain = 'NSGlobalDomain')
    key = defaults[:key]
    value = defaults[:value]
    type = defaults[:type] || type_from_value(value)
    execute "defaults write #{domain} #{key} -#{type} #{value}" do
      not_if "defaults read #{domain} #{key} | grep -q -E '^#{value}$'"
    end
  end

  def defaults_from_hash defaults_by_domain
    defaults_by_domain.each do |domain, defaults_list|
      defaults_list.each do |defaults|
        execute_macos_defaults(defaults, domain)
      end
    end
  end

  def defaults_from_array defaults_list
    defaults_list.each do |defaults|
      execute_macos_defaults(defaults)
    end
  end
end
