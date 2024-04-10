{
  config,
  lib,
  pkgs,
  ...
}:

{
  nixpkgs.overlays = [ (import ./overlays/sheldon.nix) ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "ngrok" ];
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

    # go
    pkgs.go
    pkgs.gopls
    pkgs.delve
    pkgs.golangci-lint

    # javascript
    pkgs.fnm

    # other langs
    pkgs.php
    pkgs.ruby

    # git
    pkgs.git
    pkgs.git-secrets
    pkgs.gh
    pkgs.delta
    pkgs.difftastic

    # vim
    pkgs.neovim

    # zsh
    pkgs.zsh
    pkgs.sheldon

    # tmux
    pkgs.tmux
    pkgs.reattach-to-user-namespace # only darwin

    # nix
    pkgs.nixd
    pkgs.nixfmt-rfc-style

    # middlewares
    pkgs.postgresql_16
    pkgs.mysql80
    pkgs.redis

    # tools
    pkgs.awscli2
    pkgs.buf
    pkgs.bat
    pkgs.ctop
    pkgs.direnv
    pkgs.eza
    pkgs.fzf
    pkgs.gawk
    pkgs.ghq
    pkgs.gnused
    pkgs.google-cloud-sdk
    pkgs.htop
    pkgs.jq
    pkgs.mas # only darwin
    pkgs.ngrok
    pkgs.ripgrep
    pkgs.semgrep
    pkgs.starship
    pkgs.tig
    pkgs.tree
    (pkgs.callPackage ./pkgs/aqua.nix { })

    # fonts
    pkgs.hackgen-font
    pkgs.hackgen-nf-font

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

  home.file = {
    # Create symlink with ./bin/deploy-config-files.
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
