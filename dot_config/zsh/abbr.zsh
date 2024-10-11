# https://web.archive.org/web/20180329223229/https://zshwiki.org/home/examples/zleiab
# setopt extendedglob
#
# typeset -Ag abbreviations
# abbreviations=(
# 	# "cd" "z"
# 	"ls" "eza --icons always"
# 	"ll" "eza -a -l --icons always"
# 	"la" "eza -a --icons always"
# 	"g" "git"
# 	"cm" "chezmoi"
# 	"lg" "lazygit"
# 	"pn" "pnpm"
# 	"icat" "chafa"
# 	"head" "ghead"
# 	"tail" "gtail"
# 	"sed" "gsed"
# 	"rmdsstore" "find . -name '.DS_Store' -type f -ls -delete"
# )
#
# magic-abbrev-expand() {
# 	local MATCH
# 	LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
# 	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
# 	zle self-insert
# }
#
# no-magic-abbrev-expand() {
# 	LBUFFER+=' '
# }
#
# magic-abbrev-expand-and-execute() {
# 	local MATCH
# 	LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
# 	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
# 	zle accept-line
# }
#
# zle -N magic-abbrev-expand
# zle -N no-magic-abbrev-expand
# zle -N magic-abbrev-expand-and-execute
# bindkey " " magic-abbrev-expand
# bindkey "^x " no-magic-abbrev-expand
# bindkey "^M" magic-abbrev-expand-and-execute
# bindkey -M isearch " " self-insert

bindkey ' ' expand-alias-and-self-insert

alias -g 'ls'='eza --icons always'
alias -g 'll'='eza -a -l --icons always'
alias -g 'la'='eza -a --icons always'
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
