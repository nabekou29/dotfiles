local wezterm = require("wezterm")
local act = wezterm.action

local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local config = wezterm.config_builder()

config.term = "wezterm"
config.use_ime = true
config.scrollback_lines = 35000

--- UI ---
-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = "Hardcore"
config.colors = {
  tab_bar = {
    inactive_tab_edge = "none",
  },
}

config.font = wezterm.font("Liga HackGen35Nerd")
config.font_size = 18.0

config.window_background_opacity = 0.92
config.inactive_pane_hsb = { saturation = 0.95, brightness = 0.3 }
config.adjust_window_size_when_changing_font_size = false
config.macos_window_background_blur = 10

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

config.window_frame = {
  inactive_titlebar_bg = "#121212",
  active_titlebar_bg = "#121212",
}

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
      return window:perform_action(act.SendKey({ key = dir_map[dir], mods = "CTRL|SHIFT" }), pane)
    end

    window:perform_action(act.ActivatePaneDirection(dir), pane)
  end)
end

config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "ALT", timeout_milliseconds = 1000 }

config.keys = {
  -- General
  {
    key = "c",
    mods = "CMD",
    action = act.CopyTo("ClipboardAndPrimarySelection"),
  },
  { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
  { key = "=", mods = "CMD", action = act.IncreaseFontSize },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = "f", mods = "CMD", action = act.Search({ Regex = "" }) },
  --- Tab ---
  { key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
  -- Window
  { key = "t", mods = "CMD|SHIFT", action = act.SpawnWindow },
  -- Move to tab
  { key = "LeftArrow", mods = "CMD", action = act.ActivateTabRelative(-1) },
  { key = "RightArrow", mods = "CMD", action = act.ActivateTabRelative(1) },
  -- vim like
  { key = "h", mods = "CMD", action = act.ActivateTabRelative(-1) },
  { key = "l", mods = "CMD", action = act.ActivateTabRelative(1) },
  -- close tab
  {
    key = "w",
    mods = "CMD",
    action = act.CloseCurrentPane({ confirm = true }),
  },
  {
    key = "r",
    mods = "CMD|SHIFT",
    action = act.ReloadConfiguration,
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
  {
    key = "d",
    mods = "CMD",
    action = act.SplitHorizontal({
      domain = "CurrentPaneDomain",
    }),
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  -- 移動
  {
    key = "LeftArrow",
    mods = "CMD|ALT",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "RightArrow",
    mods = "CMD|ALT",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    key = "UpArrow",
    mods = "CMD|ALT",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "DownArrow",
    mods = "CMD|ALT",
    action = act.ActivatePaneDirection("Down"),
  },
  -- vim like
  { key = "h", mods = "CMD|ALT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CMD|ALT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CMD|ALT", action = act.ActivatePaneDirection("Up") },
  {
    key = "l",
    mods = "CMD|ALT",
    action = act.ActivatePaneDirection("Right"),
  },
  { key = "h", mods = "CTRL|SHIFT", action = ActivatePaneVimSeamless("Left") },
  { key = "l", mods = "CTRL|SHIFT", action = ActivatePaneVimSeamless("Right") },
  { key = "j", mods = "CTRL|SHIFT", action = ActivatePaneVimSeamless("Down") },
  { key = "k", mods = "CTRL|SHIFT", action = ActivatePaneVimSeamless("Up") },
  -- サイズ調整
  { key = "a", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "s", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "d", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "f", mods = "CMD|ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
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
  {
    key = "Enter",
    mods = "CMD|ALT",
    action = act.TogglePaneZoomState,
  },
  {
    key = "Enter",
    mods = "CTRL|SHIFT",
    action = act.TogglePaneZoomState,
  },

  -- copy mode
  {
    key = "x",
    mods = "CTRL|SHIFT",
    action = act.ActivateCopyMode,
  },
  --Rebind OPT-Left, OPT-Right as ALT-b, ALT-f respectively to match Terminal.app behavior
  {
    key = "LeftArrow",
    mods = "ALT",
    action = act.SendKey({ key = "b", mods = "ALT" }),
  },
  {
    key = "RightArrow",
    mods = "ALT",
    action = act.SendKey({ key = "f", mods = "ALT" }),
  },
  {
    key = "o",
    mods = "CMD",
    action = wezterm.action_callback(function(window, _pane)
      local overrides = window:get_config_overrides() or {}

      local opacity_list = { 0.55, 0.92, 1.00 }
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

wezterm.on("update-right-status", function(window, pane)
  local cells = {}

  local date = wezterm.strftime("%Y/%m/%d %H:%M")
  table.insert(cells, date)

  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format("%.0f%%", b.state_of_charge * 100))
  end

  local colors = {
    "#3c1361",
    "#52307c",
    "#663a82",
    "#7c5295",
    "#b491c8",
  }

  local text_fg = "#c0c0c0"
  local default_bg = "#121212"

  local elements = {}
  local num_cells = 0

  local function push(text, is_last)
    local cell_no = num_cells + 1
    if cell_no == 1 then
      table.insert(elements, { Foreground = { Color = colors[cell_no] } })
      table.insert(elements, { Background = { Color = default_bg } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = " " .. text .. " " })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

return config
