#!/usr/bin/env bash
set -Ceu

echo "start setup..."

# Homebrew

echo "installing Homebrew ..."
which brew >/dev/null 2>&1 || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

eval "$(brew shellenv)"

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
ln -snvf "$(pwd)/shell/.zshenv" "$HOME/.zshenv"
ln -snvf "$(pwd)/shell/.zprofile" "$HOME/.zprofile"
ln -snvf "$(pwd)/shell/.abbr.zsh" "$HOME/.abbr.zsh"
ln -snvf "$(pwd)/shell/.fzf.zsh" "$HOME/.fzf.zsh"
ln -snvf "$(pwd)/shell/.anyenv.zsh" "$HOME/.anyenv.zsh"
ln -snvf "$(pwd)/shell/.completion-for-pnpm.zsh" "$HOME/.completion-for-pnpm.zsh"

# Configirations

mkdir -p "$HOME/.config/"
ln -snvf "$(pwd)/config/.gitconfig" "$HOME/.gitconfig"
ln -snvf "$(pwd)/config/git" "$HOME/.config/git"

ln -snvf "$(pwd)/config/starship.toml" "$HOME/.config/starship.toml"
mkdir -p "$HOME/.config/fsh" & ln -snvf "$(pwd)/config/fsh/overlay.ini" "$HOME/.config/fsh/overlay.ini"
mkdir -p "$HOME/.config/karabiner" & ln -snvf "$(pwd)/config/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
mkdir -p "$HOME/.config/karabiner/assets/complex_modifications" & ln -snvf "$(pwd)/config/karabiner/assets/complex_modifications" "$HOME/.config/karabiner/assets/complex_modifications"
mkdir -p "$HOME/.config/wezterm" & ln -snvf "$(pwd)/config/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
mkdir -p "$HOME/Library/Application Support/lazygit/" & ln -snvf "$(pwd)/config/lazygit.yml" "$HOME/Library/Application Support/lazygit/config.yml"
mkdir -p "$HOME/.config/sheldon" & ln -snvf "$(pwd)/config/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
ln -snvf "$(pwd)/config/hammerspoon" "$HOME/.hammerspoon"
ln -snvf "$(pwd)/config/nvim" "$HOME/.config/nvim"
# # yabai, skhd
# mkdir -p "$HOME/.config/yabai" & ln -snvf "$(pwd)/config/yabai/yabairc" "$HOME/.config/yabai/yabairc"
# mkdir -p "$HOME/.config/skhd" & ln -snvf "$(pwd)/config/skhd/skhdrc" "$HOME/.config/skhd/skhdrc"
# # for stackline
# git clone https://github.com/AdamWagner/stackline.git "$(pwd)/config/hammerspoon/stackline"
# DEFAULT_YABAI_PATH=$(echo "/usr/local/bin/yabai" | gsed -E "s/\//\\\\\//g")
# REPLACE_YABAI_PATH="$(which yabai | gsed -E "s/\//\\\\\//g")"
# gsed -i -E "s/${DEFAULT_YABAI_PATH}/${REPLACE_YABAI_PATH}/" "$(pwd)/config/hammerspoon/stackline/conf.lua"

# Anyenv
anyenv install pyenv
anyenv install nodenv
anyenv install goenv
mkdir -p "$(anyenv root)/plugins" & git clone https://github.com/znz/anyenv-update.git "$(anyenv root)/plugins/anyenv-update"
