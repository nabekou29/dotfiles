set dotenv-load := false

NIX_DIR := "$HOME/.local/share/chezmoi/nix"

# Apply nix-darwin configuration
darwin-switch:
    sudo darwin-rebuild switch --flake "{{NIX_DIR}}#default"

# Update flake inputs and apply nix-darwin configuration
darwin-update:
    nix flake update --flake "{{NIX_DIR}}"
    sudo darwin-rebuild switch --flake "{{NIX_DIR}}#default"

# Build Karabiner-Elements configuration
karabiner-build:
    deno run --allow-env --allow-read --allow-write karabiner/main.ts

# Watch and rebuild Karabiner-Elements configuration
karabiner-watch:
    deno run --allow-env --allow-read --allow-write --watch karabiner/main.ts
