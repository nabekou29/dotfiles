eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(sheldon source)"
eval "$(anyenv init -)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.config/fsh/overlay.ini ] && fast-theme -q ~/.config/fsh/overlay.ini

# Java
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export JAVA_HOME=`/usr/libexec/java_home -v "15"`
export PATH="$JAVA_HOME/bin:$PATH"

# Go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# GCloud
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

export PATH=$PATH:`npm prefix --location=global`/bin

# abbr
my_abbr() {
  keyvalue=${@: -1}
  key="${keyvalue%%=*}"
  # abbr で定義したものが存在するコマンドであることを認識させるために、alias も設定する
  alias $key="$key"
  abbr -f -qq $@
}
alias ab="my_abbr"
ab cd="z"
ab ls="eza --icons"
ab ll="eza -a -l --icons"
ab la="eza -a --icons"
ab g="git"
ab lg="lazygit"
ab pn="pnpm"
ab icat="chafa"
ab rmdsstore="find . -name '.DS_Store' -type f -ls -delete"
ab rmmergedbranch="git branch --merged | egrep -v '\*|develop|master|main' | xargs git branch -d"

ab head='ghead'
ab tail='gtail'
ab sed='gsed'

function _fzf_cd_ghq() {
    FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --reverse --height=50%"
    local root="$(ghq root)"
    local repo="$(ghq list | fzf --preview="ls -AF --color=always ${root}/{1}")"
    local dir="${root}/${repo}"
    [ -n "${dir}" ] && cd "${dir}"
    zle accept-line
    zle reset-prompt
}

zle -N _fzf_cd_ghq
bindkey "^g" _fzf_cd_ghq
