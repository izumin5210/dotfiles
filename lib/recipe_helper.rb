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

  def default_prefix
    "#{home_dir}/usr"
  end

  def default_user
    codespaces? ? "codespace" : (ENV['SUDO_USER'] || ENV['USER'])
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
end
