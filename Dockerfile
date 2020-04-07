FROM buildpack-deps:buster-scm

RUN apt-get update && \
  apt-get install -y build-essential && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

#  Timezone
#-----------------------------------------------
ENV TZ Asia/Tokyo

#  Locale
#-----------------------------------------------
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  apt-get update && apt-get install -y locales && \
  locale-gen en_US.UTF-8 && \
  update-locale LANG=en_US.UTF-8 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
ENV LC_CTYPE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

#  User
#-----------------------------------------------
ENV USER izumin
RUN useradd $USER
WORKDIR /home/$USER
RUN chown -R $USER /home/$USER
USER $USER

#  Homebrew
#-----------------------------------------------
ENV HOMEBREW_PREFIX /home/$USER/.linuxbrew

RUN git clone https://github.com/Homebrew/brew $HOMEBREW_PREFIX/Homebrew && \
  mkdir $HOMEBREW_PREFIX/bin && \
  ln -s $HOMEBREW_PREFIX/Homebrew/bin/brew $HOMEBREW_PREFIX/bin

#  Zsh
#-----------------------------------------------
RUN eval $($HOMEBREW_PREFIX/bin/brew shellenv) && \
  brew install zsh zsh-completions

COPY --chown=izumin config/.zshrc config/.zshenv ./
COPY --chown=izumin config/.zsh ./.zsh

# Use zsh for login shell
USER root
RUN chsh -s $HOMEBREW_PREFIX/bin/zsh $USER
USER $USER

# Use zsh in build
SHELL ["/home/izumin/.linuxbrew/bin/zsh", "-c"]

#  Git
#-----------------------------------------------
RUN brew install git hub git-secrets
COPY --chown=izumin config/.gitconfig config/.gitcommit-template config/.gitignore_global ./
COPY --chown=izumin config/.git_template ~/.git_template

#  Tmux
#-----------------------------------------------
RUN brew install tmux
COPY --chown=izumin config/.tmux.conf config/.gitstatus.yml ./
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
  ./.tmux/plugins/tpm/bin/install_plugins

#  fzf
#-----------------------------------------------
RUN brew install fzf && \
  $HOMEBREW_PREFIX/opt/fzf/install --key-bindings --completion --no-update-rc

#  Vim(NeoVim)
#-----------------------------------------------
RUN brew install neovim
COPY --chown=izumin config/.vimrc config/.ideavimrc ./
COPY --chown=izumin config/.vim ./.vim

COPY --chown=izumin config/.config/nvim ./.config/nvim

RUN mkdir -p ~/.vim/autoload && \
  curl -sfLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/0.10.0/plug.vim && \
  mkdir ~/.local/share/nvim/site/autoload && \
  ln ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim

RUN nvim -c PlugInstall -c qall --headless

#  Protocol Buffers
#-----------------------------------------------
RUN brew install -s libtool
RUN brew install protobuf

#  Node
#-----------------------------------------------
RUN brew install nodenv yarn
RUN nodenv install 12.13.1
RUN nodenv install 12.14.0
RUN nodenv global 12.14.0

#  Ruby
#-----------------------------------------------
RUN brew install rbenv
RUN git clone https://github.com/rbenv/rbenv-default-gems.git $(rbenv root)/plugins/rbenv-default-gems
COPY --chown=izumin config/.rbenv/default-gems ./.rbenv/

USER root
RUN apt-get update && \
  apt-get install -y libssl-dev zlib1g-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
USER $USER

RUN rbenv install 2.6.5
RUN rbenv install 2.7.0
RUN rbenv global 2.7.0

#  Go
#-----------------------------------------------
RUN brew install go
RUN go get \
  golang.org/x/tools/cmd/godoc \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/tools/cmd/guru \
  golang.org/x/tools/cmd/gopls \
  github.com/arl/gitstatus/cmd/gitstatus

RUN curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $GOBIN

#  Tools
#-----------------------------------------------
RUN brew install bat colordiff ctop direnv gibo ghq htop jq tig tree
COPY --chown=izumin config/bin .bin

#-----------------------------------------------
CMD ["/home/izumin/.linuxbrew/bin/zsh"]
