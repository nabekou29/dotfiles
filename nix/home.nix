{ pkgs, user, ... }:

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.temurin-bin-21}";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 30d --keep 1";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./modules/home/packages.nix
  ];
}
