{ pkgs, ... }:

{
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
    trash-cli
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

    ## ========== Task Runner ==========
    just

    ## ========== Monitoring / Debug ==========
    fastfetch
    fzf-make
    glow
    hyperfine
    lazysql
    lnav
    # oxker  # nixpkgs のスナップショットテスト失敗でビルド不可（2026-04-14 時点）
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
}
