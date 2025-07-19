bindkey ' ' expand-alias-and-self-insert

alias 'ls'='lsd'
alias 'la'='lsd -a'
alias 'll'='lsd -la'
alias 'g'='git'
alias 'cm'='chezmoi'
alias 'lg'='lazygit'
alias 'cl'='claude'
alias 'pn'='pnpm'
alias 'icat'='chafa'
alias 'head'='ghead'
alias 'tail'='gtail'
alias 'sed'='gsed'
alias 'docker-compose'='docker compose'
alias 'rmdsstore'='find . -name ".DS_Store" -type f -ls -delete'

expand-alias-and-self-insert() {
  local words=(${(z)LBUFFER})
  local word="${words[1]}"
  if [[ ${words[-1][1]} != '\' ]]; then
    zle _expand_alias
  fi
  zle self-insert
}

zle -N expand-alias-and-self-insert
