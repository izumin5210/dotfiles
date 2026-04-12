{
  pkgs,
  lib,
  username,
  isWorkMac,
  ...
}:

{
  system.stateVersion = 5;

  system.primaryUser = username;

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      "com.apple.trackpad.scaling" = 2.0;
    };
    dock = {
      autohide = true;
      orientation = "right";
      show-recents = false;
      tilesize = 48;
      # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
      expose-group-apps = true;
    };
    spaces = {
      # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-displays-have-separate-spaces
      spans-displays = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      CreateDesktop = false;
    };
    screencapture = {
      disable-shadow = true;
      location = "~/Downloads";
    };
    screensaver = {
      askForPassword = true;
    };
    universalaccess = {
      closeViewScrollWheelToggle = true;
    };
  };

  security.pam.services.sudo_local = {
    reattach = true;
    touchIdAuth = true;
  };

  homebrew = {
    enable = true;
    casks = [
      "azookey"
      "chatgpt"
      "claude"
      "dropbox"
      "ghostty"
      "hammerspoon"
      "jordanbaird-ice"
      "logitune"
      "karabiner-elements"
      "nani"
      "obsidian"
      "raycast"
      "setapp"
      "spotify"
      "tabtab"
      "thebrowsercompany-dia"
      "visual-studio-code"
      "nikitabobko/tap/aerospace"
    ]
    ++ (lib.optionals (!isWorkMac) [
      "1password"
      "google-chrome"
      "steam"
    ])
    ++ (lib.optionals isWorkMac [
      "notion"
    ]);
    masApps = {
      # ...
    }
    // (lib.optionalAttrs (!isWorkMac) {
      "Slack for Desktop" = 803453959;
    })
    // (lib.optionalAttrs (isWorkMac) {
      "Twingate" = 1501592214;
    });
  };

  services.tailscale.enable = true;
  nix.enable = false;
}
