require 'spec_helper'

home = ENV['HOME']

describe file("#{home}/bin") do
  it { should be_directory }
  it { should be_symlink }
end

describe file("#{home}/.zshrc") do
  it { should be_file }
  it { should be_symlink }
end

describe file("#{home}/.zshenv") do
  it { should be_file }
  it { should be_symlink }
end

describe file("#{home}/.zsh") do
  it { should be_directory }
  it { should be_symlink }
end

describe file("#{home}/.tmux.conf") do
  it { should be_file }
  it { should be_symlink }
end

describe file("#{home}/.vimrc") do
  it { should be_file }
  it { should be_symlink }
end

describe file("#{home}/.vim") do
  it { should be_directory }
  it { should be_symlink }
end

describe file("#{home}/.gvimrc") do
  it { should be_file }
  it { should be_symlink }
end

describe file("#{home}/.ideavimrc") do
  it { should be_file }
  it { should be_symlink }
end

describe file("#{home}/.rbenv") do
  it { should be_directory }
  it { should be_symlink }
end

describe file("#{home}/.pryrc") do
  it { should be_file }
  it { should be_symlink }
end

describe file("#{home}/.railsrc") do
  it { should be_file }
  it { should be_symlink }
end

describe file("#{home}/.gitconfig") do
  it { should be_file }
  it { should be_symlink }
  its(:content) { should be_include "excludesfile = ~/.gitignore_global" }
end

describe file("#{home}/.gitignore_global") do
  it { should be_file }
  it { should be_symlink }
end
