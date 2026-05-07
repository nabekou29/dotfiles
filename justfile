set dotenv-load := false

NIX_DIR := env_var('HOME') + "/.local/share/chezmoi/nix"

# Apply nix-darwin configuration
darwin-switch:
    HOME=/var/root sudo nix run 'nix-darwin' -- switch --flake "{{NIX_DIR}}#$(cat {{NIX_DIR}}/profile)"

# Update flake inputs (pinning nixpkgs to the latest Hydra-green commit) and apply nix-darwin configuration
darwin-update:
    #!/usr/bin/env bash
    set -euo pipefail
    rev=$(curl -fsSL https://channels.nixos.org/nixpkgs-unstable/git-revision)
    echo "Pinning nixpkgs to $rev"
    nix flake update --flake "{{NIX_DIR}}" --override-input nixpkgs "github:NixOS/nixpkgs/$rev"
    HOME=/var/root sudo nix run 'nix-darwin' -- switch --flake "{{NIX_DIR}}#$(cat {{NIX_DIR}}/profile)"

# Build Karabiner-Elements configuration
karabiner-build:
    deno run --allow-env --allow-read --allow-write karabiner/main.ts

# Watch and rebuild Karabiner-Elements configuration
karabiner-watch:
    deno run --allow-env --allow-read --allow-write --watch karabiner/main.ts
