{ config, pkgs, user, ... }:

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "25.11";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ## ========== Common ==========
    bat
    chezmoi
    chafa
    cloc
    coreutils
    dust
    fd
    fzf
    gnused
    imagemagick
    jq
    lsd
    nkf
    ripgrep
    sd
    timg
    tldr
    tree
    wget
    yazi
    yq-go
    zoxide

    ## ========== Terminal / Shell ==========
    mas
    sheldon
    starship
    terminal-notifier
    tmux
    zsh-completions

    ## ========== Editor ==========
    neovim
    neovim-remote

    ## ========== Git / GitHub ==========
    delta
    diff-so-fancy
    gh
    ghq
    gibo
    git
    git-lfs
    lazygit

    ## ========== macOS ==========
    macism
    watchman

    ## ========== Development ==========
    ast-grep
    bun
    cmake
    direnv
    docker-client
    hugo
    mkcert
    mold
    ninja
    pandoc
    sbt
    uv

    ## ========== Linter / Formatter ==========
    actionlint
    reviewdog
    shellcheck
    swiftlint

    ## ========== Infrastructure ==========
    infracost
    mise
    tailscale
    terraform-docs
    terraform-ls
    tflint
    trivy
    unison
    unison-fsmonitor

    ## ========== Monitoring / Debug ==========
    fastfetch
    fzf-make
    glow
    hyperfine
    lnav
    vhs

    ## ========== iOS / Mobile ==========
    cocoapods

    ## ========== Fun ==========
    cmatrix
    nyancat
    sl
  ];

  home.file = { };

  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
