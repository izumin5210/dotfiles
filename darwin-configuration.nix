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

  services.jankyborders = {
    enable = true;
    active_color = "0xffe1e3e4";
    inactive_color = "0xff494d64";
    width = 3.0;
  };

  homebrew = {
    enable = true;
    casks = [
      "alacritty"
      "chatgpt"
      "claude"
      "dropbox"
      "ghostty"
      "google-japanese-ime"
      "hammerspoon"
      "jordanbaird-ice"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "setapp"
      "spotify"
      "visual-studio-code"
      "nikitabobko/tap/aerospace"
    ]
    ++ (lib.optionals (!isWorkMac) [
      "1password"
      "google-chrome"
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

  nix.enable = false;
}
