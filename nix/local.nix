# PC 固有の設定 (git 管理外)
{ pkgs, ... }:

{
  homebrew.casks = [
    "autodesk-fusion"
    "bambu-studio"
    "blender"
    "parsec"
    "steam"
    "zoom"
  ];

  homebrew.masApps = {
    "LINE" = 539883307;
  };
}
