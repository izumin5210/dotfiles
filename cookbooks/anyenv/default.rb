git anyenv_root do
  repository 'https://github.com/riywo/anyenv'
  revision '3cb8ad1b0dfd89ed5a53fcc9e076b371f6baabfc'
end

execute "eval \"$(#{ENV['ANYENV_ROOT']}/bin/anyenv init -)\""
