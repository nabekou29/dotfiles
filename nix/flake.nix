{
  description = "nix-darwin configuration";

  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # mise はキャッシュ済み revision に pin してソースビルドを回避
    nixpkgs-mise.url = "github:nixos/nixpkgs/7a1a64774a5fd0b0cd39ac95d0e170ace8b266a0";
    # oxlint はキャッシュ済み revision に pin してソースビルドを回避
    nixpkgs-oxlint.url = "github:nixos/nixpkgs/104240a772428cc2e20d8fd86c9ddbb886bbaff2";
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
    # numtide が aarch64-darwin 含めて自前バイナリキャッシュ (cache.numtide.com) で配布しているため
    # nixpkgs.follows は意図的にしない (follows すると derivation hash が変わりキャッシュが効かなくなる)
    llm-agents.url = "github:numtide/llm-agents.nix";
    # nix-community Cachix (上で trusted-public-keys を設定済み) のキャッシュを利用するため
    # nixpkgs.follows は意図的にしない
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
  };

  outputs =
    inputs@{ nixpkgs, nix-darwin, home-manager, ... }:
    let
      user = "kohei_watanabe";
      overlays = [
        (final: prev: {
          # checkPhase が非常に遅く darwin 環境でビルドが進まないためスキップ
          direnv = prev.direnv.overrideAttrs (_: { doCheck = false; });
          mise = inputs.nixpkgs-mise.legacyPackages.${prev.stdenv.hostPlatform.system}.mise;
          oxlint = inputs.nixpkgs-oxlint.legacyPackages.${prev.stdenv.hostPlatform.system}.oxlint;
        })
        inputs.llm-agents.overlays.shared-nixpkgs
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
