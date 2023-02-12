local wezterm = require 'wezterm';
local act = wezterm.action

local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)

return {
    font = wezterm.font("Liga HackGen35Nerd"),
    use_ime = true,
    font_size = 18.0,
    tab_bar_style = {
        active_tab_left = wezterm.format {
            { Background = { Color = '#0b0022' } },
            { Foreground = { Color = '#2b2042' } },
            { Text = SOLID_LEFT_ARROW },
        },
        active_tab_right = wezterm.format {
            { Background = { Color = '#0b0022' } },
            { Foreground = { Color = '#2b2042' } },
            { Text = SOLID_RIGHT_ARROW },
        },
        inactive_tab_left = wezterm.format {
            { Background = { Color = '#0b0022' } },
            { Foreground = { Color = '#1b1032' } },
            { Text = SOLID_LEFT_ARROW },
        },
        inactive_tab_right = wezterm.format {
            { Background = { Color = '#0b0022' } },
            { Foreground = { Color = '#1b1032' } },
            { Text = SOLID_RIGHT_ARROW },
        },
    },
    -- https://wezfurlong.org/wezterm/colorschemes/index.html
    color_scheme = "Hardcore (base16)",
    --color_scheme = "Neon (terminal.sexy)",
    --color_scheme = "Hybrid (Gogh)",
    --color_scheme = "MaterialOcean",
    --color_scheme = "Edge Dark (base16)",
    --color_scheme = "Gigavolt (base16)",
    --color_scheme = "Mashup Colors (terminal.sexy)",
    --color_scheme = "Operator Mono Dark",
    window_background_opacity = 0.9,
    hide_tab_bar_if_only_one_tab = true,
    adjust_window_size_when_changing_font_size = false,
    keys = {
        { key = 'LeftArrow', mods = 'CMD|ALT', action = act.ActivateTabRelative(-1) },
        { key = 'RightArrow', mods = 'CMD|ALT', action = act.ActivateTabRelative(1) },
        {
            key = 'd',
            mods = 'CMD',
            action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
        },
        {
            key = 'd',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
        },
        {
            key = 'w',
            mods = 'CMD',
            action = wezterm.action.CloseCurrentPane { confirm = true },
        },
        {
            key = 'LeftArrow',
            mods = 'CMD',
            action = act.ActivatePaneDirection 'Left',
        },
        {
            key = 'RightArrow',
            mods = 'CMD',
            action = act.ActivatePaneDirection 'Right',
        },
        {
            key = 'UpArrow',
            mods = 'CMD',
            action = act.ActivatePaneDirection 'Up',
        },
        {
            key = 'DownArrow',
            mods = 'CMD',
            action = act.ActivatePaneDirection 'Down',
        },
    }
}