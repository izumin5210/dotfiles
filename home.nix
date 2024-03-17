{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = user.name;
  # home.homeDirectory = user.homeDir;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    # pkgs.go

    # git
    pkgs.git-secrets
    pkgs.gh
    pkgs.difftastic

    # vim
    pkgs.neovim

    # go
    pkgs.gopls
    pkgs.delve
    pkgs.golangci-lint

    # tmux
    pkgs.tmux
    pkgs.reattach-to-user-namespace # for darwin

    pkgs.buf
    pkgs.bat
    pkgs.direnv
    pkgs.fzf
    pkgs.ghq
    pkgs.gawk
    pkgs.gnused
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tig
    pkgs.tree

    # desktop app for darwin
    pkgs.alacritty

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    "bin/".source = config/bin;

    # git
    ".config/git/config.base".source = config/.config/git/config.base;
    ".config/git/ignore".source      = config/.config/git/ignore;
    ".config/gh/config.yml".source   = config/.config/gh/config.yml;

    # zsh
    ".config/zsh/legacy/".source = config/.config/zsh/legacy;

    # tmux
    ".config/tmux/tmux.base.conf".source = config/.config/tmux/tmux.base.conf;

    # vim
    ".config/nvim/".source = config/.config/nvim;

    # ripgrep
    ".ripgreprc".source = config/.ripgreprc;

    # alacritty
    ".config/alacritty/".source = config/.config/alacritty;

    # karabiner
    ".config/karabiner/".source = config/.config/karabiner;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/masayuki.izumi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs= {
    git = {
      enable = true;
      extraConfig = {
        include = {
          path = "${config.home.homeDirectory}/.config/git/config.base";
        };
        pager = {
          log  = "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight | less";
          show = "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight | less";
          diff = "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight | less";
        };
        interactive = {
          diffFilter = "${pkgs.git}/share/git/contrib/diff-highlight/diff-highlight";
        };
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      dotDir = ".config/zsh";
      initExtra = ''
        source $HOME/.config/zsh/legacy/.zshrc
      '';
      envExtra = ''
        source $HOME/.config/zsh/legacy/.zshenv
      '';
    };
    tmux = {
      enable = true;
      extraConfig = ''
        source $HOME/.config/tmux/tmux.base.conf
      '';
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
