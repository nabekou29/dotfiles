local wezterm = require 'wezterm';
local act = wezterm.action

return {
    window_decorations = "RESIZE",
    font = wezterm.font("Liga HackGen35Nerd"),
    use_ime = true,
    font_size = 18.0,
    term = 'wezterm',
    -- https://wezfurlong.org/wezterm/colorschemes/index.html
    color_scheme = "Hardcore",
    -- color_scheme = "Hardcore (base16)",
    -- color_scheme = "Neon (terminal.sexy)",
    -- color_scheme = "Hybrid (Gogh)",
    -- color_scheme = "MaterialOcean",
    -- color_scheme = "Edge Dark (base16)",
    -- color_scheme = "Gigavolt (base16)",
    -- color_scheme = "Mashup Colors (terminal.sexy)",
    -- color_scheme = "Operator Mono Dark",
    window_background_opacity = 0.92,
    inactive_pane_hsb = { saturation = 0.95, brightness = 0.3 },
    hide_tab_bar_if_only_one_tab = true,
    adjust_window_size_when_changing_font_size = false,
    --- Key Binding ---
    -- https://wezfurlong.org/wezterm/config/lua/keyassignment/index.html
    disable_default_key_bindings = true,
    leader = { key = 'a', mods = 'ALT', timeout_milliseconds = 1000 },
    keys = { -- General
        {
            key = 'c',
            mods = 'CMD',
            action = act.CopyTo 'ClipboardAndPrimarySelection'
        }, { key = 'v',   mods = 'CMD',       action = act.PasteFrom 'Clipboard' },
        { key = '=',          mods = 'CMD',       action = wezterm.action.IncreaseFontSize },
        { key = '-',          mods = 'CMD',       action = wezterm.action.DecreaseFontSize },
        { key = 'f',          mods = 'CMD',       action = act.Search { Regex = '' } }, --- Tab
        --- Tab ---
        { key = 't',          mods = 'CMD',       action = act.SpawnTab 'CurrentPaneDomain' },
        { key = '{',          mods = 'SHIFT|ALT', action = act.MoveTabRelative( -1) },
        { key = '}',          mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
        -- Window
        { key = 't',          mods = 'CMD|SHIFT', action = act.SpawnWindow },
        -- Move to tab
        { key = 'LeftArrow',  mods = 'CMD',       action = act.ActivateTabRelative( -1) },
        { key = 'RightArrow', mods = 'CMD',       action = act.ActivateTabRelative(1) },
        -- vim like
        { key = 'h',          mods = 'CMD',       action = act.ActivateTabRelative( -1) },
        { key = 'l',          mods = 'CMD',       action = act.ActivateTabRelative(1) },
        -- close tab
        {
            key = 'w',
            mods = 'CMD',
            action = wezterm.action.CloseCurrentPane { confirm = true }
        },
        {
            key = 'r',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ReloadConfiguration
        }, { key = 'r', mods = 'CMD|ALT', action = wezterm.action.ResetTerminal },
        --- Pane ---
        -- 分割
        {
            key = 'd',
            mods = 'CMD',
            action = wezterm.action.SplitHorizontal {
                domain = 'CurrentPaneDomain'
            }
        }, {
        key = 'd',
        mods = 'CMD|SHIFT',
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
    }, --
        -- 移動
        {
            key = 'LeftArrow',
            mods = 'CMD|ALT',
            action = act.ActivatePaneDirection 'Left'
        }, {
            key = 'RightArrow',
            mods = 'CMD|ALT',
            action = act.ActivatePaneDirection 'Right'
        },
        {
            key = 'UpArrow',
            mods = 'CMD|ALT',
            action = act.ActivatePaneDirection 'Up'
        }, {
            key = 'DownArrow',
            mods = 'CMD|ALT',
            action = act.ActivatePaneDirection 'Down'
        },

        -- vim like
        { key = 'h', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Left' },
        { key = 'j', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Down' },
        { key = 'k', mods = 'CMD|ALT', action = act.ActivatePaneDirection 'Up' },
        {
            key = 'l',
            mods = 'CMD|ALT',
            action = act.ActivatePaneDirection 'Right'
        }, --
        -- サイズ調整
        { key = 'a', mods = 'CMD|ALT', action = act.AdjustPaneSize { 'Left', 5 } },
        { key = 's', mods = 'CMD|ALT', action = act.AdjustPaneSize { 'Down', 5 } },
        { key = 'd', mods = 'CMD|ALT', action = act.AdjustPaneSize { 'Up', 5 } },
        { key = 'f', mods = 'CMD|ALT', action = act.AdjustPaneSize { 'Right', 5 } },
        --
        -- 場所替え
        { key = 'b', mods = 'CTRL',    action = act.RotatePanes 'CounterClockwise' },
        { key = 'n', mods = 'CTRL',    action = act.RotatePanes 'Clockwise' },
        {
            key = '0',
            mods = 'CTRL',
            action = act.PaneSelect { mode = 'SwapWithActive' }
        }, --
        -- 最大化
        {
            key = 'Enter',
            mods = 'CMD|ALT',
            action = wezterm.action.TogglePaneZoomState
        }

    },
    --- Mouse Binding ---
    disable_default_mouse_bindings = false,
    mouse_bindings = {
        {
            event = { Drag = { streak = 1, button = 'Left' } },
            mods = 'CMD',
            action = act.DisableDefaultAssignment
        }, {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'CMD',
        action = act.OpenLinkAtMouseCursor
    }
    }
}
