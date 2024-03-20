{ pkgs, ... }:

{
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

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
