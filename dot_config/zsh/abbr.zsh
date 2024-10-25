bindkey ' ' expand-alias-and-self-insert

alias -g 'ls'='lsd'
alias -g 'la'='lsd -a'
alias -g 'll'='lsd -la'
alias -g 'g'='git'
alias -g 'cm'='chezmoi'
alias -g 'lg'='lazygit'
alias -g 'pn'='pnpm'
alias -g 'icat'='chafa'
alias -g 'head'='ghead'
alias -g 'tail'='gtail'
alias -g 'sed'='gsed'
alias -g 'rmdsstore'='find . -name ".DS_Store" -type f -ls -delete'

expand-alias-and-self-insert() {
  local words=(${(z)LBUFFER})
  local word="${words[1]}"
  if [[ ${words[-1][1]} != '\' ]]; then
    zle _expand_alias
  fi
  zle self-insert
}

zle -N expand-alias-and-self-insert
