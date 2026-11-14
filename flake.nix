{
  description = "Home Manager configuration of masayuki.izumi";

  inputs = {
    # Pick up Go security fixes for Tailscale promptly from the stable release branch.
    nixpkgs.url = "github:NixOS/nixpkgs/release-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Pinned to a release tag because upstream treats Nix as best-effort and main may break.
    # nixpkgs is not followed: hermes requires the Python minor version pinned in its own lock.
    hermes-agent.url = "github:NousResearch/hermes-agent/v0.21.6";
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
        {
          hostname,
          username,
          isWorkMac,
          homeModules ? [ ],
        }:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin-configuration.nix
            home-manager.darwinModules.home-manager
            {
              users.users.${username}.home = "/Users/${username}";
              home-manager.users.${username}.imports = [ ./home.nix ] ++ homeModules;
            }
          ];
          specialArgs = { inherit inputs username isWorkMac; };
        };
    in
    {
      # MacBook Air, M3 (personal)
      darwinConfigurations."fleur" = mkDarwinSystem {
        hostname = "fleur";
        username = "izumin";
        isWorkMac = false;
      };

      # Mac mini, M4 (personal)
      darwinConfigurations."rabbithouse" = mkDarwinSystem {
        hostname = "rabbithouse";
        username = "izumin";
        isWorkMac = false;
        homeModules = [
          # Only the package comes from Nix. Hermes's Home Manager module is not used because its
          # managed mode rewrites ~/.hermes/.env on every switch and blocks `hermes config set`;
          # config and the launchd gateway are managed with the standard hermes CLI instead.
          (
            { pkgs, ... }:
            {
              home.packages = [ inputs.hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.default ];
            }
          )
        ];
      };

      # MacBook Pro, M4 Pro (work)
      darwinConfigurations."GFW3CPVPT2" = mkDarwinSystem {
        hostname = "GFW3CPVPT2";
        username = "masayuki.izumi";
        isWorkMac = true;
      };
    };
}
