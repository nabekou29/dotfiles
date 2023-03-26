#!/usr/bin/env bash
set -Ceu

echo "start setup..."

# Homebrew

echo "installing Homebrew ..."
which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

echo "run brew doctor ..."
which brew >/dev/null 2>&1 && brew doctor

echo "run brew update ..."
brew update

echo "run brew upgrade ..."
brew upgrade

echo "run brew install ..."
brew bundle --file "$(pwd)/brew/Brewfile"

echo "run brew cleanup ..."
brew cleanup

export PATH="/opt/homebrew/bin:$PATH"

# Shell
ln -snvf "$(pwd)/shell/.zshrc" "$HOME/.zshrc"
ln -snvf "$(pwd)/shell/.zprofile" "$HOME/.zprofile"
# TODO: fisher のinstallとかを追加
mkdir -p "$HOME/.config/fish" & ln -snvf "$(pwd)/shell/fish/config.fish" "$HOME/.config/fish/config.fish"
mkdir -p "$HOME/.config/fish" & ln -snvf "$(pwd)/shell/fish/completions" "$HOME/.config/fish/completions"
mkdir -p "$HOME/.config/fish" & ln -snvf "$(pwd)/shell/fish/conf.d" "$HOME/.config/fish/conf.d"
mkdir -p "$HOME/.config/fish" & ln -snvf "$(pwd)/shell/fish/functions" "$HOME/.config/fish/functions"
mkdir -p "$HOME/.config/fish" & ln -snvf "$(pwd)/shell/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"

# Configirations

ln -snvf "$(pwd)/config/.gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.config/" & ln -snvf "$(pwd)/config/starship.toml" "$HOME/.config/starship.toml"
mkdir -p "$HOME/.config/karabiner" & ln -snvf "$(pwd)/config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
mkdir -p "$HOME/.config/karabiner/assets/complex_modifications" & ln -snvf "$(pwd)/config/karabiner/assets/complex_modifications" "$HOME/.config/karabiner/assets/complex_modifications"
# iterm2 は消すかも。WezTermに移行検討中
mkdir -p "$HOME/.config/iterm2" & ln -snvf "$(pwd)/config/iterm2/com.googlecode.iterm2.plist" "$HOME/.config/iterm2/com.googlecode.iterm2.plist"
mkdir -p "$HOME/.config/wezterm" & ln -snvf "$(pwd)/config/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
mkdir -p "$HOME/Library/Application Support/lazygit/" & ln -snvf "$(pwd)/config/lazygit.yml" "$HOME/Library/Application Support/lazygit/config.yml"
ln -snvf "$(pwd)/config/hammerspoon" "$HOME/.hammerspoon"
ln -snvf "$(pwd)/config/nvim" "$HOME/nvim"
# yabai, skhd
mkdir -p "$HOME/.config/yabai" & ln -snvf "$(pwd)/config/yabai/yabairc" "$HOME/.config/yabai/yabairc"
mkdir -p "$HOME/.config/skhd" & ln -snvf "$(pwd)/config/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
# for stackline
git clone https://github.com/AdamWagner/stackline.git "$(pwd)/config/hammerspoon/stackline"
DEFAULT_YABAI_PATH=$(echo "/usr/local/bin/yabai" | gsed -E "s/\//\\\\\//g")
REPLACE_YABAI_PATH="$(which yabai | gsed -E "s/\//\\\\\//g")"
gsed -i -E "s/${DEFAULT_YABAI_PATH}/${REPLACE_YABAI_PATH}/" "$(pwd)/config/hammerspoon/stackline/conf.lua"

# Anyenv
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
mkdir -p "$(anyenv root)/plugins" & git clone https://github.com/znz/anyenv-update.git "$(anyenv root)/plugins/anyenv-update"
