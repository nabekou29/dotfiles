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
mkdir -p "$HOME/.config/" & ln -snvf "$(pwd)/shell/fish" "$HOME/.config/fish"

# Configirations

mkdir -p "$HOME/.config/" & ln -snvf "$(pwd)/config/starship.toml" "$HOME/.config/starship.toml"
mkdir -p "$HOME/.config/karabiner" & ln -snvf "$(pwd)/config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
mkdir -p "$HOME/.config/karabiner/assets/complex_modifications" & ln -snvf "$(pwd)/config/karabiner/assets/complex_modifications" "$HOME/.config/karabiner/assets/complex_modifications"
mkdir -p "$HOME/.config/iterm2" & ln -snvf "$(pwd)/config/iterm2/com.googlecode.iterm2.plist" "$HOME/.config/iterm2/com.googlecode.iterm2.plist"

# Anyenv
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
exec $SHELL -l
