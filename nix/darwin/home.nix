{ pkgs, user, ... }:

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
    git-cliff
    git-lfs
    git-wt
    lazygit

    ## ========== macOS ==========
    macism
    watchman

    ## ========== Language Runtime ==========
    bun
    deno
    go
    nodejs
    python3
    ruby
    rustup
    temurin-bin-21
    typescript

    ## ========== Development ==========
    ast-grep
    cmake
    docker-client
    hugo
    mkcert
    mold
    ninja
    pandoc
    sbt
    uv

    ## ========== Language Server ==========
    biome
    codebook
    copilot-language-server
    golangci-lint-langserver
    gopls
    lua-language-server
    pyright
    stylelint-lsp
    tailwindcss-language-server
    terraform-ls
    typescript-language-server
    vscode-langservers-extracted
    yaml-language-server

    ## ========== Linter / Formatter ==========
    actionlint
    eslint_d
    golangci-lint
    oxfmt
    oxlint
    prettierd
    prettier
    reviewdog
    ruff
    shellcheck
    shfmt
    stylua
    swiftlint
    taplo

    ## ========== Infrastructure ==========
    infracost
    mise
    tailscale
    terraform-docs
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
    tree-sitter
    vhs
    vim-startuptime
    watchexec

    ## ========== CLI Tools ==========
    agent-browser
    codex
    gemini-cli
    github-copilot-cli
    octorus
    playwright
    zenn-cli

    ## ========== iOS / Mobile ==========
    cocoapods

    ## ========== Fun ==========
    cmatrix
    nyancat
    sl
  ];

  home.file = { };

  home.sessionVariables = {
    JAVA_HOME = "${pkgs.temurin-bin-21}";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
