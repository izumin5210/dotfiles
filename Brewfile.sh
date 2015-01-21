brew update
brew upgrade

brew tap homebrew/science
brew tap sanemat/font
brew tap caskroom/cask
brew tap caskroom/fonts
brew tap caskroom/versions

# ==== cask ====
brew install brew-cask

# ==== xquartz ====
brew cask install xquartz

# ================================================================
# formulas
# ================================================================

brew install git
brew install zsh --disable-etc-dir
brew install zsh-completions
brew install vim --with-lua
brew install macvim --with-lua
brew install tmux
brew install reattach-to-user-namespace

brew install rbenv
brew install ruby-build
brew install rbenv-gem-rehash
brew install android-sdk
brew install android-ndk
brew install lua
brew install nodebrew

brew install hub
brew install heroku-toolbelt
brew install imagemagick
brew install pngquant
brew install gnuplot --with-x --latex
brew install gcc
brew install jq
brew install curl
brew install highlight
brew install tree
brew install tig
brew install git-flow
brew install ino
brew install fig

brew install mysql
brew install redis
brew install postgresql
brew install chromedriver
brew install terminal-notifier

# ==== science ====
brew install R

# ==== sanemat/font ====
# > Error: /usr/local/opt/automake not present or broken
# > Please reinstall automake. Sorry :(
brew install automake

brew install ricty --vim-powerline

# ==== after brew brew install ====
brew linkapps
brew cleanup

# ================================================================
# casks
# ================================================================

brew cask update

brew cask install alfred && brew cask alfred link

brew cask install android-studio
brew cask install iterm2
brew cask install arduino
# brew cask install fritzing
# brew cask install leap-motion
brew cask install mactex
# brew cask install titanium-studio
brew cask install virtualbox
brew cask install vagrant
# brew cask install java
brew cask install skim

brew cask install google-chrome
brew cask install google-japanese-ime
brew cask install firefox
brew cask install evernote
brew cask install skitch
brew cask install dropbox
brew cask install copy
brew cask install airserver
brew cask install flash-player
brew cask install unity-web-player
# cask brew install filezilla
brew cask install skype
brew cask install kobito
# brew cask install yorufukurou
brew cask install dash
brew cask install sequel-pro
brew cask install adobe-creative-cloud
# brew cask install soundflower
brew cask install slack
brew cask install karabiner

brew cask install caffeine
brew cask install appcleaner
brew cask install day-o
# brew cask install tuneinstructor
brew cask install hyperswitch
brew cask install tinkertool
brew cask install bettertouchtool
brew cask install monolingual
brew cask install lyrics-master
brew cask install the-unarchiver
brew cask install android-file-transfer
brew cask install pandoc
# brew cask install selfcontrol
# brew cask install shortcat
brew cask install boot2docker

# PDF to Keynote
# Degrees
# Simplenote
# FlashLight

# ================================================================
# versions
# ================================================================


# ================================================================
# fonts
# ================================================================

brew cask install font-inconsolata
brew cask install font-fontawesome
brew cask install font-m-plus

brew cask cleanup

