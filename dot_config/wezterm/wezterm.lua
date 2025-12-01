local wezterm = require("wezterm")
local act = wezterm.action
local fonts = require("fonts")
local tabline = require("tabline")

local config = wezterm.config_builder()

config.term = "wezterm"
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL" -- IME に SHIFT or CTRL を渡す。これがないと C-m とかのキーバインドが動かない。
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
config.inactive_pane_hsb = { saturation = 0.95, brightness = 0.3 }
config.adjust_window_size_when_changing_font_size = false
config.macos_window_background_blur = 10

config.window_decorations = "RESIZE"
config.window_padding = { left = 0, right = 0, top = 4, bottom = 0 }

config.window_frame = {
  inactive_titlebar_bg = "#121212",
  active_titlebar_bg = "#121212",
}

-- タブラインのセットアップ
tabline.setup_tabline(wezterm, config)

--- Key Binding ---

local function ActivatePaneVimSeamless(dir)
  local dir_map = {
    Left = "h",
    Down = "j",
    Up = "k",
    Right = "l",
  }

  return wezterm.action_callback(function(window, pane)
    -- neovim の場合は何もしない
    local p_name = pane:get_foreground_process_name()
    if p_name:find("neovim") or p_name:find("nvim") or p_name:find("vim") or p_name:find("chezmoi") then
      return window:perform_action(act.SendKey({ key = dir_map[dir], mods = "SHIFT|CTRL" }), pane)
    end

    window:perform_action(act.ActivatePaneDirection(dir), pane)
  end)
end

config.disable_default_key_bindings = true
config.leader = { key = "\\", mods = "ALT", timeout_milliseconds = 1000 }

config.keys = {
  -- General
  { key = "c", mods = "CMD", action = act.CopyTo("ClipboardAndPrimarySelection") },
  { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
  { key = "=", mods = "CMD", action = act.IncreaseFontSize },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = "f", mods = "CMD", action = act.Search({ Regex = "" }) },
  { key = "n", mods = "CMD", action = act.SpawnWindow },
  { key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
  --- Tab ---
  { key = "n", mods = "SHIFT|ALT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
  -- Window
  { key = "t", mods = "CMD|SHIFT", action = act.SpawnWindow },
  -- Move to tab
  -- vim like
  { key = "h", mods = "SHIFT|ALT", action = act.ActivateTabRelative(-1) },
  { key = "l", mods = "SHIFT|ALT", action = act.ActivateTabRelative(1) },
  -- close tab
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "w", mods = "SHIFT|ALT", action = act.CloseCurrentPane({ confirm = true }) },
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
  --- Pane ---
  -- 分割
  { key = "v", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "s", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  -- 移動
  { key = "h", mods = "CMD|ALT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CMD|ALT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CMD|ALT", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CMD|ALT", action = act.ActivatePaneDirection("Right") },
  { key = "h", mods = "SHIFT|CTRL", action = ActivatePaneVimSeamless("Left") },
  { key = "l", mods = "SHIFT|CTRL", action = ActivatePaneVimSeamless("Right") },
  { key = "j", mods = "SHIFT|CTRL", action = ActivatePaneVimSeamless("Down") },
  { key = "k", mods = "SHIFT|CTRL", action = ActivatePaneVimSeamless("Up") },
  -- サイズ調整
  { key = "a", mods = "ALT|CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "s", mods = "ALT|CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "d", mods = "ALT|CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "f", mods = "ALT|CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },
  --
  -- 場所替え
  -- { key = 'b', mods = 'CTRL', action = act.RotatePanes 'CounterClockwise' },
  -- { key = 'n', mods = 'CTRL', action = act.RotatePanes 'Clockwise' },
  {
    key = "0",
    mods = "CTRL",
    action = act.PaneSelect({ mode = "SwapWithActive" }),
  },
  -- 最大化
  { key = "Enter", mods = "SHIFT|ALT", action = act.TogglePaneZoomState },
  { key = "Enter", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },

  -- copy mode
  { key = "x", mods = "ALT", action = act.ActivateCopyMode },

  -- --Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  -- {
  --   key = "LeftArrow",
  --   mods = "ALT",
  --   action = act.SendKey({ key = "b", mods = "ALT" }),
  -- },
  -- {
  --   key = "RightArrow",
  --   mods = "ALT",
  --   action = act.SendKey({ key = "f", mods = "ALT" }),
  -- },
  {
    key = "o",
    mods = "CMD",
    action = wezterm.action_callback(function(window, _pane)
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

  {
    key = "q",
    mods = "OPT",
    action = wezterm.action_callback(function(window, pane)
      local target_pane_id = tostring(pane:pane_id())

      -- Try to resume existing editor pane
      local success, stdout, stderr = wezterm.run_child_process({
        "/bin/zsh",
        "-lc",
        string.format("bunx --silent editprompt@latest --resume --mux wezterm --target-pane %s", target_pane_id),
      })

      -- If resume failed, create new editor pane
      if not success then
        window:perform_action(
          act.SplitPane({
            direction = "Down",
            size = { Cells = 10 },
            command = {
              args = {
                "/bin/zsh",
                "-lc",
                string.format(
                  "bunx --silent editprompt@latest --editor nvim --always-copy --mux wezterm --target-pane %s",
                  target_pane_id
                ),
              },
            },
          }),
          pane
        )
      end
    end),
  },

  {
    mods = "ALT|SHIFT",
    key = "s",
    action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
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
