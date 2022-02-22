starship init fish | source

# direnv
eval (direnv hook fish)

# gh
eval (gh completion -s fish| source)

# PATHを設定
set PATH $TO_FISH_PATH $PATH

set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"

abbr -a ls exa --icons
abbr -a ll exa -a -l --icons
abbr -a la exa -a --icons
abbr -a rmdsstore find . -name '.DS_Store' -type f -ls -delete
abbr -a rmmergedbranch "git branch --merged | egrep -v '\*|develop|master' | xargs git branch -d"
abbr -a g git

abbr -a head ghead
abbr -a tail gtail
abbr -a sed gsed

if test -e ~/.config/fish/config.local.fish
    . ~/.config/fish/config.local.fish
end
