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

# ヒストリー機能
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups # 重複するコマンド行は古い方を削除
setopt hist_ignore_dups # 直前と同じコマンドラインはヒストリに追加しない
setopt share_history # コマンド履歴ファイルを共有する
setopt append_history # 履歴を追加 (毎回 .zsh_history を作るのではなく)
setopt inc_append_history # 履歴をインクリメンタルに追加
setopt hist_no_store # historyコマンドは履歴に登録しない
setopt hist_reduce_blanks # 余分な空白は詰めて記録
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
setopt auto_cd # ディレクトリ名だけで移動

# 色の設定
export LSCOLORS=Exfxcxdxbxegedabagacad
# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export ZLS_COLORS=$LS_COLORS
export CLICOLOR=true
# 補完候補に色を付ける
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' menu select=1 # 補完候補のカーソル選択を有効に

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:${FPATH}

  autoload -Uz compinit
  compinit
fi

# eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"
_evalcache starship init zsh


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
source "$HOME/.completion-for-pnpm.zsh"
# pnpm end

# abbr
source "$HOME/.abbr.zsh"

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

if [ -f ~/.zshrc.local ] ; then
  source ~/.zshrc.local
fi

# zprof
