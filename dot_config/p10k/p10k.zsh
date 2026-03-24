# Powerlevel10k configuration — Iceberg theme with powerline style
# Generated to match previous oh-my-posh config.
# Docs: https://github.com/romkatv/powerlevel10k/blob/master/README.md

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh
  setopt no_unset extended_glob

  # Unset all configuration options to allow reloading
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # ── General ──────────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_MODE=nerdfont-v3
  typeset -g POWERLEVEL9K_ICON_PADDING=moderate
  typeset -g POWERLEVEL9K_ICON_BEFORE_CONTENT=
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

  # ── Instant Prompt ──────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # ── Segment Layout ──────────────────────────────────────────────────────────
  # Line 1: dir / git / languages / gcloud / exec_time
  # Line 2: prompt char (> or ✗)
  # Right:  time
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir
    vcs
    deno_version          # custom segment
    go_version
    node_version
    python
    rust_version
    lua_version
    gcloud
    command_execution_time
    # --- line 2 ---
    newline
    prompt_char
  )

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    time
  )

  # ── Separators (powerline) ──────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR='\uE0B0'
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='\uE0B1'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\uE0B0'
  typeset -g POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=''

  # ── dir ──────────────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_DIR_BACKGROUND='#5c76ae'
  typeset -g POWERLEVEL9K_DIR_FOREGROUND='#15161e'
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=false
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#33374e'
  typeset -g POWERLEVEL9K_DIR_VISUAL_IDENTIFIER_EXPANSION=$'\uF07C'

  # ── vcs (git) ───────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION=
  typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND='#2d4a5e'
  typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='#2d4a5e'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='#2d4a5e'
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND='#2d4a5e'
  typeset -g POWERLEVEL9K_VCS_LOADING_BACKGROUND='#2d4a5e'
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=0

  # Custom VCS formatter (stash・tag 非表示)
  function my_git_formatter() {
    emulate -L zsh
    local branch_icon=$'\uF418'

    if (( $1 )); then
      # Detailed (async) info available
      local       meta='%f'
      local      clean='%F{#89b8c2}'
      local   modified='%F{#e2a478}'
      local  untracked='%F{#84a0c6}'
      local conflicted='%F{#e27878}'

      local res="${clean}${branch_icon} ${VCS_STATUS_LOCAL_BRANCH:-${VCS_STATUS_COMMIT[1,8]}}"

      # Upstream ahead/behind
      (( VCS_STATUS_COMMITS_BEHIND )) && res+=" ${meta}⇣${VCS_STATUS_COMMITS_BEHIND}"
      (( VCS_STATUS_COMMITS_AHEAD  )) && res+=" ${meta}⇡${VCS_STATUS_COMMITS_AHEAD}"
      # Staged
      (( VCS_STATUS_NUM_STAGED     )) && res+=" ${modified}+${VCS_STATUS_NUM_STAGED}"
      # Unstaged
      (( VCS_STATUS_NUM_UNSTAGED   )) && res+=" ${modified}!${VCS_STATUS_NUM_UNSTAGED}"
      # Untracked
      (( VCS_STATUS_NUM_UNTRACKED  )) && res+=" ${untracked}?${VCS_STATUS_NUM_UNTRACKED}"
      # Conflicted
      (( VCS_STATUS_NUM_CONFLICTED )) && res+=" ${conflicted}~${VCS_STATUS_NUM_CONFLICTED}"

      typeset -g my_git_format=$res
    else
      # Loading state — show branch only
      typeset -g my_git_format="${branch_icon} ${VCS_STATUS_LOCAL_BRANCH:-${VCS_STATUS_COMMIT[1,8]}}"
    fi
  }
  functions -M my_git_formatter 2>/dev/null

  typeset -g POWERLEVEL9K_VCS_CONTENT_EXPANSION='${$((my_git_formatter(1)))+${my_git_format}}'
  typeset -g POWERLEVEL9K_VCS_LOADING_CONTENT_EXPANSION='${$((my_git_formatter(0)))+${my_git_format}}'

  # ── Language versions (shared background) ───────────────────────────────────
  local lang_bg='#263156'

  # go
  typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND=$lang_bg
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND='#7fd5ea'
  typeset -g POWERLEVEL9K_GO_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_GO_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\uE627'
  typeset -g POWERLEVEL9K_GO_VERSION_CONTENT_EXPANSION='${P9K_CONTENT%.*}'

  # node
  typeset -g POWERLEVEL9K_NODE_VERSION_BACKGROUND=$lang_bg
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#6ca35e'
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\uED0D'
  typeset -g POWERLEVEL9K_NODE_VERSION_CONTENT_EXPANSION='${P9K_CONTENT%.*}'

  # python
  typeset -g POWERLEVEL9K_PYTHON_BACKGROUND=$lang_bg
  typeset -g POWERLEVEL9K_PYTHON_FOREGROUND='#ffd43b'
  typeset -g POWERLEVEL9K_PYTHON_VISUAL_IDENTIFIER_EXPANSION=$'\uE73C'
  typeset -g POWERLEVEL9K_PYTHON_CONTENT_EXPANSION='${P9K_CONTENT%.*}'

  # rust
  typeset -g POWERLEVEL9K_RUST_VERSION_BACKGROUND=$lang_bg
  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#e27878'
  typeset -g POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_RUST_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\uE7A8'
  typeset -g POWERLEVEL9K_RUST_VERSION_CONTENT_EXPANSION='${P9K_CONTENT%.*}'

  # lua
  typeset -g POWERLEVEL9K_LUA_VERSION_BACKGROUND=$lang_bg
  typeset -g POWERLEVEL9K_LUA_VERSION_FOREGROUND='#51a0cf'
  typeset -g POWERLEVEL9K_LUA_VERSION_PROJECT_ONLY=true
  typeset -g POWERLEVEL9K_LUA_VERSION_VISUAL_IDENTIFIER_EXPANSION=$'\uE620'

  # ── gcloud ──────────────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_GCLOUD_BACKGROUND=$lang_bg
  typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND='#e5e510'
  # $SHOW_GCLOUD が設定されている場合のみ表示、プロジェクト ID のみ (メアド非表示)
  typeset -g POWERLEVEL9K_GCLOUD_VISUAL_IDENTIFIER_EXPANSION=$'${${SHOW_GCLOUD:+\uF0C2}}'
  typeset -g POWERLEVEL9K_GCLOUD_CONTENT_EXPANSION='${${SHOW_GCLOUD:+$P9K_GCLOUD_PROJECT_ID}}'

  # ── command_execution_time ──────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND='#374478'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#c6c8d1'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=5
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION=$'\uF252'

  # ── prompt_char (line 2) ────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#b4be82'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#e27878'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='>'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='>'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='>'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='>'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=false
  # Override error content to show ✗ instead of >
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION=$'\u2717'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION=$'\u2717'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_CONTENT_EXPANSION=$'\u2717'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_CONTENT_EXPANSION=$'\u2717'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''

  # ── time (right prompt) ────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_TIME_BACKGROUND=
  typeset -g POWERLEVEL9K_TIME_FOREGROUND='#84a0c6'
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_TIME_UPDATE_ON_COMMAND=true
  typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=

  # ── Custom: deno_version ────────────────────────────────────────────────────
  # p10k has no built-in deno segment, so we define a custom one.
  function prompt_deno_version() {
    [[ -f deno.json || -f deno.jsonc || -f deno.lock ]] || return
    (( $+commands[deno] )) || return
    local v=${$(deno --version 2>/dev/null | head -1)#deno }
    [[ -n $v ]] || return
    p10k segment -b '#263156' -f '#3c82f6' -i $'\ue7c0' -t "${v%.*}"
  }

  # ── Transient prompt ────────────────────────────────────────────────────────
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  (( ! $+functions[p10k] )) || p10k reload
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
