# check initilize speed: `time zsh -i -c exit`
# zmodload zsh/zprof

# /opt/homebrew/bin/brew か、/usr/local/bin/brew が存在する場合はそれを使う
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
  export PATH="/usr/local/bin:$PATH"
fi

eval "$(sheldon source)"

_evalcache starship init zsh
_evalcache direnv hook zsh
_evalcache mise activate zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Java
export JAVA_HOME=`/usr/libexec/java_home`
export PATH="$JAVA_HOME/bin:$PATH"

# Go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Android
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# GCloud
zsh-defer source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
zsh-defer source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# Deno
export PATH="$HOME/.deno/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# abbr
zsh-defer source "$HOME/.abbr.zsh"

# zoxide
zsh-defer _evalcache zoxide init zsh

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

zsh-defer source "$HOME/.completion-for-pnpm.zsh"

# terminfo
# ~/.terminfo がなければダウンロードする
if [ ! -d ~/.terminfo ]; then
  # https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines
  tempfile=$(mktemp) \
  && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo \
  && tic -x -o ~/.terminfo $tempfile \
  && rm $tempfile
fi
export TERM=wezterm

# mise に置き換えを試している
# source ~/.anyenv.zsh

if [ -f ~/.zshrc.local ] ; then
. ~/.zshrc.local
fi

# zprof
