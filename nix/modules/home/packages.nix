{ pkgs, inputs, ... }:

let
  abbrs = pkgs.rustPlatform.buildRustPackage {
    pname = "abbrs";
    version = "0.2.10";
    src = pkgs.fetchFromGitHub {
      owner = "ushironoko";
      repo = "abbrs";
      rev = "v0.2.10";
      hash = "sha256-YQ0pPYBK7fCEM0fAGiBHHo6/NacJfpgLNNCOuKEsaqs=";
    };
    cargoHash = "sha256-CRwwsXyFBSFuVw4Z00VQSSyNqZX8OTGD2nzwHJUO8lI=";
  };

  herdr =
    let
      version = "0.4.11";
      sources = {
        "aarch64-darwin" = {
          url = "https://github.com/ogulcancelik/herdr/releases/download/v${version}/herdr-macos-aarch64";
          hash = "sha256-/N2KQAnQof/cBD4PuUlSHpKzWo1/3RILYJXGRmp6/9A=";
        };
      };
      source = sources.${pkgs.stdenv.hostPlatform.system}
        or (throw "herdr: unsupported system ${pkgs.stdenv.hostPlatform.system}");
    in
    pkgs.stdenv.mkDerivation {
      pname = "herdr";
      inherit version;
      src = pkgs.fetchurl source;
      dontUnpack = true;
      installPhase = ''
        runHook preInstall
        install -Dm755 $src $out/bin/herdr
        runHook postInstall
      '';
      meta = {
        description = "Supervise multiple coding agents in one terminal";
        homepage = "https://github.com/ogulcancelik/herdr";
        license = pkgs.lib.licenses.agpl3Only;
        platforms = builtins.attrNames sources;
        mainProgram = "herdr";
      };
    };

  trev = inputs.trev.packages.${pkgs.stdenv.hostPlatform.system}.default;
in

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
    abbrs
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
    gws
    herdr
    octorus
    playwright
    trev
    zenn-cli

    ## ========== iOS / Mobile ==========
    cocoapods

    ## ========== Fun ==========
    cmatrix
    nyancat
    sl
  ];
}
