{ pkgs, user, ... }:

{
  # Determinate Nix が Nix デーモンを管理するため無効化
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  system.primaryUser = user;
  system.stateVersion = 6;

  # Touch ID で sudo 認証
  security.pam.services.sudo_local.touchIdAuth = true;

  imports = [
    ./modules/darwin/macos-defaults.nix
    ./modules/darwin/homebrew.nix
  ];
}
