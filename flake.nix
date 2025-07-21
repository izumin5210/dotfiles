{
  description = "Home Manager configuration of masayuki.izumi";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
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
      # MacBook Air, M3 (personal)
      darwinConfigurations."fleur" = mkDarwinSystem {
        hostname = "fleur";
        username = "izumin";
      };

      # Mac mini, M4 (personal)
      darwinConfigurations."rabbithouse" = mkDarwinSystem {
        hostname = "rabbithouse";
        username = "izumin";
      };

      # MacBook Pro, M1 Pro (work)
      darwinConfigurations."CM2NX3M6CH" = mkDarwinSystem {
        hostname = "CM2NX3M6CH";
        username = "masayuki.izumi";
      };

      # MacBook Pro, M4 Pro (work)
      darwinConfigurations."GFW3CPVPT2" = mkDarwinSystem {
        hostname = "GFW3CPVPT2";
        username = "masayuki.izumi";
      };
    };
}
