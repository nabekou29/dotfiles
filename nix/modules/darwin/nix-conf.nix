{ inputs, user, ... }:

{
  imports = [ inputs.determinate.darwinModules.default ];

  # Determinate Nix が /etc/nix/nix.conf を管理し !include nix.custom.conf を読み込む。
  # customSettings はその nix.custom.conf に書き出される。
  determinateNix.customSettings = {
    trusted-users = [ "root" "@admin" user ];
    extra-substituters = [
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
