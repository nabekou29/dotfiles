local wezterm = require("wezterm")
local act = wezterm.action
local fonts = require("fonts")

local config = wezterm.config_builder()

config.term = "wezterm"
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL" -- IME に SHIFT or CTRL を渡す。これがないと C-m とかのキーバインドが動かない。
-- Alt (Option) を TUI (herdr など) に Alt modifier として送る
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.use_dead_keys = false
config.scrollback_lines = 35000
--- UI ---
-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = "Iceberg (Gogh)"
config.colors = {
  compose_cursor = "#b8d099",
}

local font_info = fonts.font(
  -- "Monaspace Neon Var"
  -- "Monaspace Argon Var"
  -- "Monaspace Xenon Var"
  -- "Monaspace Radon Var"
  -- "Monaspace Krypton Var"
  -- "Moralerspace Neon"
  -- "Moralerspace Argon"
  -- "Moralerspace Radon"
  "Moralerspace Krypton"
  -- "HackGen35 Console NF"
  -- "Fira Code"
)

config.font = font_info.font
config.font_size = font_info.font_size
config.line_height = font_info.line_height
config.harfbuzz_features = font_info.harfbuzz_features

config.window_background_opacity = 0.92
config.adjust_window_size_when_changing_font_size = false
config.macos_window_background_blur = 10

config.window_decorations = "RESIZE"
config.window_padding = { left = 0, right = 0, top = 4, bottom = 0 }

config.window_frame = {
  inactive_titlebar_bg = "#121212",
  active_titlebar_bg = "#121212",
}

-- ペイン/タブ/ワークスペース管理は herdr に委ねるため、タブバーは非表示
config.enable_tab_bar = false

--- Key Binding ---

config.disable_default_key_bindings = true

config.keys = {
  -- General
  { key = "c", mods = "CMD", action = act.CopyTo("ClipboardAndPrimarySelection") },
  { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
  { key = "=", mods = "CMD", action = act.IncreaseFontSize },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = "n", mods = "CMD", action = act.SpawnWindow },
  { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
  -- Window
  { key = "t", mods = "CMD|SHIFT", action = act.SpawnWindow },
  -- close
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
  {
    key = "r",
    mods = "CMD|SHIFT",
    action = wezterm.action_callback(function(window, _pane)
      window:perform_action(act.ReloadConfiguration, _pane)
      window:set_config_overrides({})
    end),
  },
  { key = "r", mods = "CMD|ALT", action = act.ResetTerminal },
  {
    key = "f",
    mods = "CMD",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(act.Search("CurrentSelectionOrEmptyString"), pane)
      window:perform_action(
        act.Multiple({
          act.CopyMode("ClearPattern"),
          act.CopyMode("ClearSelectionMode"),
          act.CopyMode("MoveToScrollbackBottom"),
        }),
        pane
      )
    end),
  },

  -- copy mode
  { key = "x", mods = "ALT", action = act.ActivateCopyMode },

  {
    key = "o",
    mods = "CMD",
    action = wezterm.action_callback(function(window)
      local overrides = window:get_config_overrides() or {}

      local opacity_list = { 0.55, 0.8, 0.92, 1.00 }
      local current_opacity = overrides.window_background_opacity or 0.95

      local idx = 1
      for i, opacity in ipairs(opacity_list) do
        if opacity > current_opacity then
          overrides.window_background_opacity = opacity
          break
        end
        idx = i
      end
      if idx == #opacity_list then
        overrides.window_background_opacity = opacity_list[1]
      end

      window:set_config_overrides(overrides)
    end),
  },
}

--- Mouse Binding ---
config.disable_default_mouse_bindings = false
config.mouse_bindings = {
  {
    event = { Drag = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = act.DisableDefaultAssignment,
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = act.OpenLinkAtMouseCursor,
  },
}

return config
