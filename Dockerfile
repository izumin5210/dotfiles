FROM buildpack-deps:buster-scm

RUN apt-get update && \
  # homebrew
  apt-get install -y build-essential && \
  # rbenv
  apt-get install -y libssl-dev zlib1g-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
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

#-----------------------------------------------
# Zsh
RUN eval $($HOMEBREW_PREFIX/bin/brew shellenv) && \
  brew install zsh zsh-completions

# Use zsh for login shell
USER root
RUN chsh -s $HOMEBREW_PREFIX/bin/zsh $USER
USER $USER

ENV PATH /home/$USER/.linuxbrew/bin:$PATH

# Git
RUN brew install git hub git-secrets

# Tmux
RUN brew install tmux

# fzf
RUN brew install fzf && \
  $HOMEBREW_PREFIX/opt/fzf/install --key-bindings --completion --no-update-rc

# Vim(NeoVim)
RUN brew install neovim

# Protocol Buffers
RUN brew install -s libtool
RUN brew install protobuf

# Tools
RUN brew install bat colordiff ctop direnv gibo ghq htop jq tig tree

# Ruby
RUN brew install rbenv
RUN git clone https://github.com/rbenv/rbenv-default-gems.git $(rbenv root)/plugins/rbenv-default-gems
COPY --chown=$USER config/.rbenv/default-gems ./.rbenv/

USER root
USER $USER

RUN rbenv install 2.7.0
RUN rbenv global 2.7.0

# Node
RUN brew install nodenv yarn
RUN nodenv install 12.14.0
RUN nodenv global 12.14.0

# Go
RUN brew install go


#-----------------------------------------------
# Zsh
COPY --chown=$USER config/.zshrc config/.zshenv ./
COPY --chown=$USER config/.zsh ./.zsh

SHELL ["/home/izumin/.linuxbrew/bin/zsh", "-c"]

# Git
COPY --chown=$USER config/.gitconfig config/.gitcommit-template config/.gitignore_global ./
COPY --chown=$USER config/.git_template ~/.git_template

# tmux
COPY --chown=$UESR config/.tmux.conf config/.gitstatus.yml ./
RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
  ./.tmux/plugins/tpm/bin/install_plugins
RUN go get github.com/arl/gitstatus/cmd/gitstatus

# vim
COPY --chown=$UESR config/.vim ./.vim
COPY --chown=$UESR config/.vimrc config/.ideavimrc ./
COPY --chown=$UESR config/.config/nvim ./.config/nvim

RUN mkdir -p ~/.vim/autoload && \
  curl -sfLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/0.10.0/plug.vim && \
  mkdir ~/.local/share/nvim/site/autoload && \
  ln ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim

RUN nvim -c PlugInstall -c qall --headless

# Bin
COPY --chown=$UESR config/bin .bin

# Go
RUN go get \
  golang.org/x/tools/cmd/godoc \
  golang.org/x/tools/cmd/goimports \
  golang.org/x/tools/cmd/guru \
  golang.org/x/tools/gopls

RUN curl -sfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $GOBIN

#-----------------------------------------------
CMD ["/home/izumin/.linuxbrew/bin/zsh"]
