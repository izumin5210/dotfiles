{
  description = "Home Manager configuration of masayuki.izumi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }:
    let
      mkDarwinSystem =
        { hostname, username }:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              users.users.${username}.home = "/Users/${username}";
              home-manager.users.${username} = import ./home.nix;
            }
          ];
          specialArgs = { inherit inputs; };
        };
    in
    {
      darwinConfigurations."fleur" = mkDarwinSystem {
        hostname = "fleur";
        username = "izumin";
      };

      darwinConfigurations."CM2NX3M6CH" = mkDarwinSystem {
        hostname = "CM2NX3M6CH";
        username = "masayuki.izumi";
      };
    };
}
