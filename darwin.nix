{ pkgs, ... }:

{
  system.defaults = {
    dock.autohide = true;
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
}
