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

  homebrew = {
    enable = true;
    casks = [
      "alacritty"
      "azookey"
      "chatgpt"
      "claude"
      "dropbox"
      "ghostty"
      "hammerspoon"
      "jordanbaird-ice"
      "karabiner-elements"
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

  launchd.daemons.colima = {
    command = ''
      ${pkgs.colima}/bin/colima start \
        --foreground \
        --vm-type=vz \
        --cpu=2 --memory=8 --disk=100 \
        --network-address
    '';
    serviceConfig = {
      Label = "local.colima";
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
        NetworkState = true;
      };
      UserName = username;
      EnvironmentVariables = {
        HOME = "/Users/${username}";
        PATH = "${pkgs.colima}/bin:${pkgs.lima}/bin:${pkgs.docker}/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
      WorkingDirectory = "/Users/${username}";
      StandardOutPath = "/tmp/colima-autostart.out.log";
      StandardErrorPath = "/tmp/colima-autostart.err.log";
    };
  };

  services.tailscale.enable = true;

  nix.enable = false;
}
