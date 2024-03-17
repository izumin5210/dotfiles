{
  description = "Home Manager configuration of masayuki.izumi";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      users = [
        { username = "izumin"; homeDir = "/Users/izumin"; hostname = "fleur"; }
        { username = "masayuki.izumi"; homeDir = "/Users/masayuki.izumi"; hostname = "CM2NX3M6CH"; }
      ];

      genHomeConfigurations = usersList: builtins.foldl' (acc: user:
        acc // {
          "${user.username}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              { home.username = user.username; home.homeDirectory = user.homeDir; }
              ./home.nix
            ];
          };
        }
      ) { } usersList;

      genDarwinConfigurations = usersList: builtins.foldl' (acc: user:
        acc // {
          "${user.hostname}" = nix-darwin.lib.darwinSystem {
            inherit pkgs;
            modules = [ ./darwin-configuration.nix ];
          };
        }
      ) { } usersList;
    in {
      homeConfigurations = genHomeConfigurations users;
      darwinConfigurations = genDarwinConfigurations users;
    };
}
