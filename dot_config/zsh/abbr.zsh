# https://web.archive.org/web/20180329223229/https://zshwiki.org/home/examples/zleiab
setopt extendedglob

typeset -Ag abbreviations
abbreviations=(
	# "cd" "z"
	"ls" "eza --icons always"
	"ll" "eza -a -l --icons always"
	"la" "eza -a --icons always"
	"g" "git"
	"cm" "chezmoi"
	"lg" "lazygit"
	"pn" "pnpm"
	"icat" "chafa"
	"head" "ghead"
	"tail" "gtail"
	"sed" "gsed"
	"rmdsstore" "find . -name '.DS_Store' -type f -ls -delete"
)

magic-abbrev-expand() {
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
	zle self-insert
}

no-magic-abbrev-expand() {
	LBUFFER+=' '
}

magic-abbrev-expand-and-execute() {
	local MATCH
	LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
	LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
	zle accept-line
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
zle -N magic-abbrev-expand-and-execute
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand
bindkey "^M" magic-abbrev-expand-and-execute
bindkey -M isearch " " self-insert
