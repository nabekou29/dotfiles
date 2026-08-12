set dotenv-load := false

# List available recipes
default:
    @just --list

# Apply Brewfile and mise tools (mise run apply のエイリアス)
apply:
    mise run apply

# Update brew and mise tools (mise run update のエイリアス)
update:
    mise run update

# Build Karabiner-Elements configuration
karabiner-build:
    deno run --allow-env --allow-read --allow-write karabiner/main.ts

# Watch and rebuild Karabiner-Elements configuration
karabiner-watch:
    deno run --allow-env --allow-read --allow-write --watch karabiner/main.ts
