{ pkgs, user, ... }:

{
  # Determinate Nix が Nix デーモンを管理するため無効化
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  # stylelint-lsp の nativeBuildInputs で使われる pnpm がビルド時のみ必要
  # nixpkgs が pnpm 新版に追従したら削除する
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-9.15.9"
  ];

  system.primaryUser = user;
  system.stateVersion = 6;

  # Touch ID で sudo 認証
  security.pam.services.sudo_local.touchIdAuth = true;

  imports = [
    ./modules/darwin/macos-defaults.nix
    ./modules/darwin/homebrew.nix
    ./modules/darwin/nix-conf.nix
  ];
}
