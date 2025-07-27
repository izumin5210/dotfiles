{
  pkgs,
  lib,
  isWorkMac,
  ...
}:

{
  system.stateVersion = 5;

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

  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    enable = true;
    casks =
      [
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
      ]
      ++ (lib.optionals (!isWorkMac) [
        "1password"
        "google-chrome"
      ]);
    masApps =
      {
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
