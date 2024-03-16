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
    };
    screensaver = {
      askForPassword = true;
    };
    screencapture = {
      location = "~/Downloads";
    };
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
