alias ab="abbr -f -qq "
ab cd="z"
ab ls="eza --icons always"
ab ll="eza -a -l --icons always"
ab la="eza -a --icons always"
ab g="git"
ab lg="lazygit"
ab pn="pnpm"
ab icat="chafa"
ab rmdsstore="find . -name '.DS_Store' -type f -ls -delete"
ab rmmergedbranch="git branch --merged | egrep -v '\*|develop|master|main' | xargs git branch -d"

ab head='ghead'
ab tail='gtail'
ab sed='gsed'
