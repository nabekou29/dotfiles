# check initilize speed: `time zsh -i -c exit`
# zmodload zsh/zprof

eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(sheldon source)"

# eval "$(starship init zsh)"
_evalcache starship init zsh
_evalcache zoxide init zsh
_evalcache direnv hook zsh
_evalcache anyenv init -

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
zsh-defer source "$HOME/.abbr.zsh"

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

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

# zprof
