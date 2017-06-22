package 'git'
package 'hub'
package 'tig'
package 'gibo'
package 'git-secrets'

dotfile '.gitconfig'
dotfile '.gitcommit-template'
dotfile '.gitignore_global'
dotfile '.git_template'
dotfile_template '.gitconfig.local' do
  source File.expand_path('../templates/gitconfig_local.erb', __FILE__)
end
