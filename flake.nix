{
  description = "Home Manager configuration of masayuki.izumi";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";
      username = "masayuki.izumi";
      hostname = "CM2NX3M6CH";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      darwinConfigurations = {
        ${hostname} = nix-darwin.lib.darwinSystem {
          # system = "aarch64-darwin";
          system = system;
          inherit pkgs;
          modules = [
            ./darwin.nix
              home-manager.nixosModules.home-manager
            # ({ pkgs, lib, ... }: {
            #  home-manager.useGlobalPkgs = true;
            #  home-manager.useUserPackages = true;
            #  home-manager.users."masayuki.izumi" = { ... }: {
            #  imports = [ ./home.nix ];
            #  };
            #  })
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              users.users."masayuki.izumi".home = "/Users/${username}";
              home-manager.users."masayuki.izumi" = import ./home.nix;
            }
          ];
        };
      };
    };
}
