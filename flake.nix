{
  description = "Home Manager configuration of masayuki.izumi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."masayuki.izumi" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };

      darwinConfigurations."masayuki.izumi" = nix-darwin.lib.darwinSystem {
        inherit pkgs;
        system = system;
        modules = [
          ./darwin.nix
          {
            home-manager.useUserPackages = true;
            home-manager.users."masayuki.izumi" = self.homeConfigurations."masayuki.izumi".activationPackage;
          }
        ];
      };
    };
}
