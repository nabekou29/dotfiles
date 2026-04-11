set dotenv-load := false

CHEZMOI_DIR := "~/.local/share/chezmoi"

# Apply nix-darwin configuration
darwin-switch:
    sudo darwin-rebuild switch --flake '{{CHEZMOI_DIR}}/nix#default'

# Update flake inputs and apply nix-darwin configuration
darwin-update:
    nix flake update --flake {{CHEZMOI_DIR}}/nix
    sudo darwin-rebuild switch --flake '{{CHEZMOI_DIR}}/nix#default'

# Build Karabiner-Elements configuration
karabiner-build:
    deno run --allow-env --allow-read --allow-write karabiner/main.ts

# Watch and rebuild Karabiner-Elements configuration
karabiner-watch:
    deno run --allow-env --allow-read --allow-write --watch karabiner/main.ts
