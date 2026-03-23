#!/bin/zsh
set -euo pipefail

input=$(cat)

# --- ANSI Colors ---
RESET=$'\033[0m'
BOLD=$'\033[1m'
DIM=$'\033[2m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
CYAN=$'\033[36m'
BLUE=$'\033[34m'
MAGENTA=$'\033[35m'

# --- NerdFont Progress Bar Characters ---
PF_LEFT=$'\uEE03'   # progress_full_left
PF_MID=$'\uEE04'    # progress_full_mid
PF_RIGHT=$'\uEE05'  # progress_full_right
PE_LEFT=$'\uEE00'   # progress_empty_left
PE_MID=$'\uEE01'    # progress_empty_mid
PE_RIGHT=$'\uEE02'  # progress_empty_right

# --- NerdFont Icons ---
ICON_MODEL=$'\U000F06A9'  # 󰚩 nf-md-robot
ICON_CTX=$'\U000F035B'    # 󰍛 nf-md-memory
ICON_RATE=$'\uF0E7'       #  nf-fa-bolt

SEP="${DIM} │ ${RESET}"

# --- Helpers ---
jval() { echo "$input" | jq -r "$1 // empty" }

threshold_color() {
    local val=${1:-0}
    if (( val >= 80 )); then
        print -n "$RED"
    elif (( val >= 50 )); then
        print -n "$YELLOW"
    else
        print -n "$GREEN"
    fi
}

# build_progress_bar <percentage> <total_segments>
build_progress_bar() {
    local pct=${1:-0}
    local segs=${2:-10}
    local filled=$(( pct * segs / 100 ))
    (( filled > segs )) && filled=$segs
    (( filled < 0 )) && filled=0

    local bar="" last=$(( segs - 1 ))
    for (( i = 0; i < segs; i++ )); do
        if (( i == 0 )); then
            (( i < filled )) && bar+="$PF_LEFT" || bar+="$PE_LEFT"
        elif (( i == last )); then
            (( i < filled )) && bar+="$PF_RIGHT" || bar+="$PE_RIGHT"
        else
            (( i < filled )) && bar+="$PF_MID" || bar+="$PE_MID"
        fi
    done
    print -n "$bar"
}

# ===== Build sections =====

model=$(jval '.model.display_name')
pct=$(jval '.context_window.used_percentage')
pct_int=${pct%.*}
pct_int=${pct_int:-0}

ctx_color=$(threshold_color "$pct_int")
ctx_bar=$(build_progress_bar "$pct_int" 10)

sec_model="${BOLD}${MAGENTA}${ICON_MODEL} ${model}${RESET}"
sec_ctx="${ctx_color}${ICON_CTX} ${ctx_bar} ${pct_int}%${RESET}"

# Rate limits (Max plan, available after first API call)
rate_5h=$(jval '.rate_limits.five_hour.used_percentage')
rate_7d=$(jval '.rate_limits.seven_day.used_percentage')
sec_rate=""
vis_rate=0
if [[ -n "$rate_5h" ]] || [[ -n "$rate_7d" ]]; then
    rate_parts=()
    rate_vis=0
    if [[ -n "$rate_5h" ]]; then
        r5=${rate_5h%.*}; r5=${r5:-0}
        r5_color=$(threshold_color "$r5")
        r5_bar=$(build_progress_bar "$r5" 10)
        r5_reset=$(jval '.rate_limits.five_hour.resets_at')
        r5_remaining=""
        if [[ -n "$r5_reset" ]]; then
            now=$(date +%s)
            left=$(( r5_reset - now ))
            (( left < 0 )) && left=0
            lh=$(( left / 3600 ))
            lm=$(( (left % 3600) / 60 ))
            r5_remaining="${DIM}(${lh}h${lm}m)${RESET}"
        fi
        rate_parts+=("${r5_color}5h ${r5_bar} ${r5}%${RESET}${r5_remaining:+ ${r5_remaining}}")
        r5_rem_vis=0
        [[ -n "$r5_remaining" ]] && r5_rem_vis=$(( 1 + ${#lh} + 1 + ${#lm} + 3 ))  # space + "(" + h + "h" + m + "m)"
        (( rate_vis += 2 + 1 + 10 + 1 + ${#r5} + 1 + r5_rem_vis ))
    fi
    if [[ -n "$rate_7d" ]]; then
        r7=${rate_7d%.*}; r7=${r7:-0}
        r7_color=$(threshold_color "$r7")
        r7_bar=$(build_progress_bar "$r7" 10)
        r7_reset=$(jval '.rate_limits.seven_day.resets_at')
        r7_remaining=""
        if [[ -n "$r7_reset" ]]; then
            [[ -z "$now" ]] && now=$(date +%s)
            left=$(( r7_reset - now ))
            (( left < 0 )) && left=0
            ld=$(( left / 86400 ))
            lh=$(( (left % 86400) / 3600 ))
            r7_remaining="${DIM}(${ld}d${lh}h)${RESET}"
        fi
        rate_parts+=("${r7_color}7d ${r7_bar} ${r7}%${RESET}${r7_remaining:+ ${r7_remaining}}")
        r7_rem_vis=0
        [[ -n "$r7_remaining" ]] && r7_rem_vis=$(( 1 + ${#ld} + 1 + ${#lh} + 3 ))  # space + "(" + d + "d" + h + "h)"
        (( rate_vis += 2 + 1 + 10 + 1 + ${#r7} + 1 + r7_rem_vis ))
    fi
    sec_rate="${ICON_RATE} ${(j: :)rate_parts}"
    vis_rate=$(( 2 + 1 + rate_vis + ${#rate_parts} - 1 ))  # icon + space + parts + spaces between
fi

# ===== Estimate visible width =====
vis_model=$(( 2 + 1 + ${#model} ))               # icon(2col) + space + model name
vis_ctx=$(( 2 + 1 + 10 + 1 + ${#pct_int} + 1 ))  # icon(2col) + space + bar(10) + space + pct + "%"
sep_w=3  # " │ "
sections=2
[[ -n "$sec_rate" ]] && (( sections++ ))
# Reserve space for Claude Code's right-side text (e.g. " current: 2.1.81 · latest: 2.1.81")
right_reserved=40
total_w=$(( vis_model + vis_ctx + vis_rate + sep_w * (sections - 1) + right_reserved ))

cols=${COLUMNS:-$(tput cols </dev/tty 2>/dev/null)} 2>/dev/null
cols=${cols:-80}

# ===== Output =====
if (( total_w <= cols )); then
    # Single line
    line="${sec_model}${SEP}${sec_ctx}"
    [[ -n "$sec_rate" ]] && line+="${SEP}${sec_rate}"
    print "$line"
else
    # Two lines
    print "${sec_model}  ${sec_ctx}"
    [[ -n "$sec_rate" ]] && print "${sec_rate}"
fi
