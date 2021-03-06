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
mkdir -p "$HOME/.config/iterm2" & ln -snvf "$(pwd)/config/iterm2/com.googlecode.iterm2.plist" "$HOME/.config/iterm2/com.googlecode.iterm2.plist"

# Anyenv
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
mkdir -p "$(anyenv root)/plugins" & git clone https://github.com/znz/anyenv-update.git "$(anyenv root)/plugins/anyenv-update"