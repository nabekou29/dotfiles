# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$(brew --prefix)/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$(brew --prefix)/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

# Ctrl + G で ghq リポジトリ選択
function ghq-fzf() {
    local selected_dir=$(ghq list | fzf --query="$LBUFFER")

    if [ -n "$selected_dir" ]; then
        BUFFER="cd $(ghq root)/${selected_dir}"
        zle accept-line
    fi

    zle reset-prompt
}
zle -N ghq-fzf
bindkey "^g" ghq-fzf

# Option + F でファイル/ディレクトリ選択（プレビュー付き）
fzf-file-widget-preview() {
  local prefix="${LBUFFER##* }"
  local lbuf_prefix="${LBUFFER% *} "
  local search_dir="." query="" path_prefix=""

  if [[ "$LBUFFER" != *" "* ]]; then
    prefix="$LBUFFER"
    lbuf_prefix=""
  elif [[ "$LBUFFER" == *" " ]]; then
    prefix=""
    lbuf_prefix="$LBUFFER"
  fi

  if [[ -n "$prefix" ]]; then
    local expanded="${prefix/#\~/$HOME}"
    if [[ -d "$expanded" ]]; then
      search_dir="$expanded"
      path_prefix="${prefix%/}/"
    elif [[ "$prefix" == */* ]]; then
      local dir="${expanded%/*}"
      [[ -z "$dir" ]] && dir="/"
      if [[ -d "$dir" ]]; then
        search_dir="$dir"
        path_prefix="${prefix%/*}/"
        query="${prefix##*/}"
      fi
    else
      query="$prefix"
    fi
  fi

  local preview='
    f={}; [[ "$f" != /* ]] && f="'"$search_dir"'/$f"
    if [[ -d "$f" ]]; then
      lsd --color=always --icon=always -la "$f"
    elif [[ "$f" =~ \.(png|jpe?g|gif|bmp|webp|svg|ico)$ ]]; then
      chafa -s 80x24 "$f" 2>/dev/null || file "$f"
    elif [[ "$f" =~ \.pdf$ ]]; then
      pdftoppm -f 1 -l 1 -png "$f" 2>/dev/null | chafa -s 80x24 || file "$f"
    else
      bat --color=always --style=numbers --line-range=:500 "$f" 2>/dev/null || cat "$f"
    fi
  '

  local selected=$(cd "$search_dir" 2>/dev/null && fd --hidden . 2>/dev/null | fzf --query "$query" --preview "$preview" --preview-window 'right:50%:wrap')
  [[ -n "$selected" ]] && LBUFFER="${lbuf_prefix}${path_prefix}${selected}"
  zle redisplay
}
zle -N fzf-file-widget-preview
bindkey '^[f' fzf-file-widget-preview

