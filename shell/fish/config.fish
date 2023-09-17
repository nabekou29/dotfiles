# PATHを設定
set PATH $TO_FISH_PATH $PATH

set -U FZF_LEGACY_KEYBINDINGS 0
set -U FZF_REVERSE_ISEARCH_OPTS "--reverse --height=100%"

abbr -a cd z
abbr -a ls exa --icons
abbr -a ll exa -a -l --icons
abbr -a la exa -a --icons
abbr -a g git
abbr -a pn pnpm
abbr -a icat chafa
abbr -a rmdsstore find . -name '.DS_Store' -type f -ls -delete
abbr -a rmmergedbranch "git branch --merged | egrep -v '\*|develop|master|main' | xargs git branch -d"

abbr -a head ghead
abbr -a tail gtail
abbr -a sed gsed

starship init fish | source

set -g direnv_fish_mode eval_on_arrow    # trigger direnv at prompt, and on every arrow-based directory change (default)
set -g direnv_fish_mode eval_after_arrow # trigger direnv at prompt, and only after arrow-based directory changes before executing command
set -g direnv_fish_mode disable_arrow    # trigger direnv at prompt only, this is similar functionality to the original behavior

# direnv
direnv hook fish | source

# gh
eval (gh completion -s fish| source)

function github-copilot_helper
    set -l TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli $argv[1] "$argv[2..]" --shellout $TMPFILE
        if [ -e "$TMPFILE" ]
            set -l FIXED_CMD (cat $TMPFILE)
            eval "$FIXED_CMD" 
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

set -U fish_features qmark-noglob
alias ??='github-copilot_helper what-the-shell'
alias git?='github-copilot_helper git-assist'
alias gh?='github-copilot_helper gh-assist'


if test -e ~/.config/fish/config.local.fish
    . ~/.config/fish/config.local.fish
end

# https://github.com/ajeetdsouza/zoxide
zoxide init fish | source

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

# google-cloud-sdk
source "$(brew --prefix)/share/google-cloud-sdk/path.fish.inc"
