#!/bin/bash

if [ ! -d ~/.terminfo ]; then
    # https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines
    tempfile=$(mktemp) &&
        curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo &&
        tic -x -o ~/.terminfo $tempfile &&
        rm $tempfile
fi
