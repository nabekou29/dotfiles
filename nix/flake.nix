{
  description = "nix-darwin configuration";

  nixConfig = {
    extra-substituters = [
      "https://numtide.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

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
    # numtide が aarch64-darwin 含めて自前 Cachix (numtide.cachix.org) でビルド済みバイナリを配布しているため
    # nixpkgs.follows は意図的にしない (follows すると derivation hash が変わりキャッシュが効かなくなる)
    llm-agents.url = "github:numtide/llm-agents.nix";
    # nix-community Cachix (上で trusted-public-keys を設定済み) のキャッシュを利用するため
    # nixpkgs.follows は意図的にしない
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    # mise は nixpkgs-unstable の直近 revision だとビルド済みバイナリがキャッシュに
    # 載っておらず、毎回ソースビルド (Rust) が走って重い。キャッシュ済みの revision に
    # pin し、overlay で mise だけ差し替える。darwin-update で nixpkgs が進んでも
    # ここは固定なので巻き添えビルドを防げる。更新したいときは下の rev を手動で上げる。
    nixpkgs-mise.url = "github:nixos/nixpkgs/8c3cede7ddc26bd659d2d383b5610efbd2c7a16e";
  };

  outputs =
    inputs@{ nixpkgs, nix-darwin, home-manager, ... }:
    let
      user = "kohei_watanabe";
      overlays = [
        (final: prev: {
          # checkPhase が非常に遅く darwin 環境でビルドが進まないためスキップ
          direnv = prev.direnv.overrideAttrs (_: { doCheck = false; });
          # mise はキャッシュ済み revision (nixpkgs-mise) から引いてソースビルドを回避
          mise = inputs.nixpkgs-mise.legacyPackages.${prev.stdenv.hostPlatform.system}.mise;
        })
        inputs.llm-agents.overlays.default
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
