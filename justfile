set dotenv-load := false

NIX_DIR := env_var('HOME') + "/.local/share/chezmoi/nix"

# List available recipes
default:
    @just --list

_check-profile:
    #!/usr/bin/env sh
    if [ ! -s "{{NIX_DIR}}/profile" ]; then
        echo "Error: {{NIX_DIR}}/profile が見つからないか空です。" >&2
        echo "プロファイル名を書き込んでください:" >&2
        echo "  echo work    > {{NIX_DIR}}/profile" >&2
        echo "  echo private > {{NIX_DIR}}/profile" >&2
        exit 1
    fi

# Apply nix-darwin configuration
darwin-switch: _check-profile
    HOME=/var/root sudo nix run 'nix-darwin' -- switch --flake "{{NIX_DIR}}#$(cat {{NIX_DIR}}/profile)"

# Update flake inputs and apply nix-darwin configuration
# キャッシュミス回避付きの更新は Claude Code の /darwin-update skill を使う
darwin-update: _check-profile
    nix flake update --flake "{{NIX_DIR}}"
    HOME=/var/root sudo nix run 'nix-darwin' -- switch --flake "{{NIX_DIR}}#$(cat {{NIX_DIR}}/profile)"

# Build Karabiner-Elements configuration
karabiner-build:
    deno run --allow-env --allow-read --allow-write karabiner/main.ts

# Watch and rebuild Karabiner-Elements configuration
karabiner-watch:
    deno run --allow-env --allow-read --allow-write --watch karabiner/main.ts
