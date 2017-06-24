module AnyenvHelper
  def anyenv_root
    "#{ENV['HOME']}/.anyenv"
  end

  def with_anyenv command
    [
      "export ANYENV_ROOT=#{anyenv_root}",
      "export PATH=${ANYENV_ROOT}/bin:${PATH}",
      'eval "$(anyenv init -)"',
      command,
    ].join(';')
  end
end

MItamae::RecipeContext.class_eval do
  include AnyenvHelper
end

MItamae::ResourceContext.class_eval do
  include AnyenvHelper
end
