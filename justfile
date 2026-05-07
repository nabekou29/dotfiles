set dotenv-load := false

NIX_DIR := env_var('HOME') + "/.local/share/chezmoi/nix"

# Apply nix-darwin configuration
darwin-switch:
    HOME=/var/root sudo nix run 'nix-darwin' -- switch --flake "{{NIX_DIR}}#$(cat {{NIX_DIR}}/profile)"

# Update flake inputs and apply nix-darwin configuration
darwin-update:
    nix flake update --flake "{{NIX_DIR}}"
    HOME=/var/root sudo nix run 'nix-darwin' -- switch --flake "{{NIX_DIR}}#$(cat {{NIX_DIR}}/profile)"

# Build Karabiner-Elements configuration
karabiner-build:
    deno run --allow-env --allow-read --allow-write karabiner/main.ts

# Watch and rebuild Karabiner-Elements configuration
karabiner-watch:
    deno run --allow-env --allow-read --allow-write --watch karabiner/main.ts
