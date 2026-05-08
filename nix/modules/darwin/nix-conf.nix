{ inputs, user, ... }:

{
  imports = [ inputs.determinate.darwinModules.default ];

  # Determinate Nix が /etc/nix/nix.conf を管理し !include nix.custom.conf を読み込む。
  # customSettings はその nix.custom.conf に書き出される。
  determinateNix.customSettings = {
    trusted-users = [ "root" "@admin" user ];
    extra-substituters = [
      "https://numtide.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
