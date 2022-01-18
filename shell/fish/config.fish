starship init fish | source

# direnv
eval (direnv hook fish)

# gh
eval (gh completion -s fish| source)

# PATHを設定
set PATH $TO_FISH_PATH $PATH

set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"

abbr -a ll ls -lhs
abbr -a la ls -A
abbr -a rmdsstore find . -name '.DS_Store' -type f -ls -delete
abbr -a rmmergedbranch "git branch --merged | egrep -v '\*|develop|master' | xargs git branch -d"
