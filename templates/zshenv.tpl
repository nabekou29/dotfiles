# op inject でシークレットを埋め込み ~/.zshenv を生成する (mise run secrets)。
# シェル起動時に op を呼ばないよう、生成物は実ファイルとして書き出す。

# export WORDCHARS='*?_-.//[]~=&;!#$%^(){}<>'
export XDG_CONFIG_HOME="$HOME/.config"
export VISUAL="vim"

export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# gh notify
# https://github.com/meiji163/gh-notify?tab=readme-ov-file#key-bindings-fzf
export GH_NOTIFY_RELOAD_KEY='ctrl-R'
export GH_NOTIFY_MARK_READ_KEY='ctrl-r'

# API Keys
export ANTHROPIC_API_KEY={{ op://Personal/claude-api-key/credential }}
export OPENAI_API_KEY={{ op://Personal/openai-api-key/credential }}
export GEMINI_API_KEY={{ op://Personal/gemini-api-key/credential }}
export FIGMA_API_KEY={{ op://Personal/figma-api-key/credential }}
export GITHUB_PERSONAL_ACCESS_TOKEN={{ op://Personal/GitHub Default Token/credential }}
# mise の GitHub API レート制限回避 (GITHUB_TOKEN はグローバルに置きたくないので mise 専用の変数で)
export MISE_GITHUB_TOKEN="$GITHUB_PERSONAL_ACCESS_TOKEN"

# Claude Code
export CLAUDE_CONFIG_DIR="$HOME/.config/claude"

export CC_PUSHOVER_API_KEY={{ op://Personal/pushover-cc/credential }}
export CC_PUSHOVER_USER_KEY={{ op://Personal/pushover-cc/username }}
