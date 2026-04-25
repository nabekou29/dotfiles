{
  description = "nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    trev = {
      url = "github:nabekou29/trev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:nabekou29/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, nix-darwin, home-manager, ... }:
    let
      user = "kohei_watanabe";
      overlays = [
        (final: prev: {
          # checkPhase が非常に遅く darwin 環境でビルドが進まないためスキップ
          direnv = prev.direnv.overrideAttrs (_: { doCheck = false; });
        })
      ];
      mkDarwinSystem = profile: nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit user inputs; };
        modules = [
          { nixpkgs.overlays = overlays; }
          ./configuration.nix
          (let p = ./hosts + "/${profile}.nix";
           in if builtins.pathExists p then p else { })
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = { inherit user inputs; };
            home-manager.users.${user} = import ./home.nix;
            users.users.${user}.home = "/Users/${user}";
          }
        ];
      };
    in
    {
      darwinConfigurations = {
        work    = mkDarwinSystem "work";
        private = mkDarwinSystem "private";
      };
    };
}
