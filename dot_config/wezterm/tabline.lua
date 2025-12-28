local M = {}

-- Powerline symbols
local SOLID_LEFT_ARROW = ""
local SOLID_RIGHT_ARROW = ""

local tb_color = {
  background = "#15161e",

  active_tab = {
    bg_color = "#7aa2f7",
    fg_color = "#15161e",
    intensity = "Bold",
  },

  inactive_tab = {
    bg_color = "#292e42",
    fg_color = "#545c7e",
  },

  inactive_tab_hover = {
    bg_color = "#3b4261",
    fg_color = "#c0caf5",
  },

  new_tab = {
    bg_color = "#15161e",
    fg_color = "#7aa2f7",
  },

  new_tab_hover = {
    bg_color = "#292e42",
    fg_color = "#7aa2f7",
  },
}

function M.setup_tabline(wezterm, config)
  -- タブバーのスタイル設定
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false
  config.show_tab_index_in_tab_bar = false
  config.hide_tab_bar_if_only_one_tab = true
  config.show_new_tab_button_in_tab_bar = false
  config.show_close_tab_button_in_tabs = false
  config.tab_max_width = 30

  -- タブバーの色設定
  config.colors.tab_bar = tb_color

  -- タブのフォーマット設定
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local title = tab.tab_title
    if #title == 0 then
      title = tab.active_pane.title
      title = title:match("^[^:]+") or title
    end

    if #title > 18 then
      title = title:sub(1, 15) .. "..."
    end

    local tab_index = tab.tab_index + 1
    local is_first = tab.tab_index == 0
    local is_last = tab.tab_index == #tabs - 1

    local elements = {}

    -- 左側のセパレータ
    if tab.is_active then
      table.insert(elements, { Background = { Color = tb_color.active_tab.bg_color } })
    else
      table.insert(elements, { Background = { Color = tb_color.inactive_tab.bg_color } })
    end
    if is_first then
      table.insert(elements, { Foreground = { Color = tb_color.background } })
    else
      table.insert(elements, { Foreground = { Color = tb_color.inactive_tab.bg_color } })
    end
    table.insert(elements, { Text = SOLID_RIGHT_ARROW })

    -- タブ本体
    if tab.is_active then
      table.insert(elements, { Background = { Color = tb_color.active_tab.bg_color } })
      table.insert(elements, { Foreground = { Color = tb_color.active_tab.fg_color } })
      table.insert(elements, { Attribute = { Intensity = "Bold" } })
    else
      table.insert(elements, { Background = { Color = tb_color.inactive_tab.bg_color } })
      table.insert(elements, { Foreground = { Color = tb_color.inactive_tab.fg_color } })
    end

    table.insert(elements, { Text = string.format(" %d  %s ", tab_index, title) })

    -- 右側のセパレータ
    if tab.is_active then
      table.insert(elements, { Foreground = { Color = tb_color.active_tab.bg_color } })
    else
      table.insert(elements, { Foreground = { Color = tb_color.inactive_tab.bg_color } })
    end
    if is_last then
      table.insert(elements, { Background = { Color = tb_color.background } })
    else
      table.insert(elements, { Background = { Color = tb_color.inactive_tab.bg_color } })
    end
    table.insert(elements, { Text = SOLID_RIGHT_ARROW })

    return elements
  end)

  -- ステータスバーの設定
  wezterm.on("update-status", function(window, pane)
    -- 左側のステータス（ワークスペース）
    local workspace = window:active_workspace()
    local workspace_bg = "#5c76ae"
    local workspace_fg = "#15161e"

    window:set_left_status(wezterm.format({
      { Background = { Color = workspace_bg } },
      { Foreground = { Color = workspace_fg } },
      { Attribute = { Intensity = "Bold" } },
      { Text = "  " .. workspace .. " " },
      { Background = { Color = "#15161e" } },
      { Foreground = { Color = workspace_bg } },
      { Text = SOLID_RIGHT_ARROW },
    }))

    local segments = {}
    local colors = {
      git = { bg = "#1d2541", fg = "#84a0c6" },
      cwd = { bg = "#263156", fg = "#89b8c2" },
      battery = { bg = "#374478", fg = "#b4be82" },
      music = { bg = "#3f4e8b", fg = "#e27878" },
      time = { bg = "#4962af", fg = "#c6c8d1" },
    }

    -- CWD
    local cwd = pane:get_current_working_dir()
    if cwd then
      cwd = cwd.file_path
      local home = os.getenv("HOME")
      if home then
        cwd = cwd:gsub("^" .. home, "~")
      end
      local parts = {}
      for part in cwd:gmatch("[^/]+") do
        table.insert(parts, part)
      end
      if #parts > 2 then
        cwd = "…/" .. parts[#parts - 1] .. "/" .. parts[#parts]
      end
    else
      cwd = "~"
    end
    cwd = " " .. cwd

    -- Git branch
    local git_branch = ""
    local cwd_for_git = pane:get_current_working_dir()
    local success, stdout =
      wezterm.run_child_process({ "git", "-C", cwd_for_git.file_path, "rev-parse", "--abbrev-ref", "HEAD" })
    if success then
      git_branch = " " .. stdout:gsub("%s+", "")
    end

    -- Battery
    local battery_info = ""
    for _, b in ipairs(wezterm.battery_info()) do
      local charge = math.floor(b.state_of_charge * 100)
      local icon = ""
      if b.state == "Charging" then
        icon = ""
      elseif charge > 90 then
        icon = ""
      elseif charge > 75 then
        icon = ""
      elseif charge > 50 then
        icon = ""
      elseif charge > 25 then
        icon = ""
      else
        icon = ""
      end
      battery_info = string.format("%s  %d%%", icon, charge)
    end

    -- Music
    local music_info = ""
    pcall(function()
      local media_control = "/opt/homebrew/bin/media-control"
      local jq = "/opt/homebrew/bin/jq"
      local jq_format = [[
      def truncate(n): if length > n then .[0:(n-3)] + "..." else . end;

      if .playing then
        " \(.title) - \(.artist)" | truncate(35)
      else
        "󰝛"
      end
      ]]

      local success, title = wezterm.run_child_process({
        "zsh",
        "-c",
        media_control .. " get -h | " .. jq .. " -r '" .. jq_format .. "'",
      })

      if success then
        music_info = title:gsub("%s+", " ")
      end
    end)

    -- Time
    local time = wezterm.strftime("%H:%M")

    -- Build segments
    local prev_bg = "#15161e"

    -- Git segment
    if git_branch ~= "" then
      table.insert(segments, { Background = { Color = prev_bg } })
      table.insert(segments, { Foreground = { Color = colors.git.bg } })
      table.insert(segments, { Text = SOLID_LEFT_ARROW })
      table.insert(segments, { Background = { Color = colors.git.bg } })
      table.insert(segments, { Foreground = { Color = colors.git.fg } })
      table.insert(segments, { Text = "  " .. git_branch .. " " })
      prev_bg = colors.git.bg
    end

    -- CWD segment
    table.insert(segments, { Background = { Color = prev_bg } })
    table.insert(segments, { Foreground = { Color = colors.cwd.bg } })
    table.insert(segments, { Text = SOLID_LEFT_ARROW })
    table.insert(segments, { Background = { Color = colors.cwd.bg } })
    table.insert(segments, { Foreground = { Color = colors.cwd.fg } })
    table.insert(segments, { Text = "  " .. cwd .. " " })
    prev_bg = colors.cwd.bg

    -- Battery segment
    if battery_info ~= "" then
      table.insert(segments, { Background = { Color = prev_bg } })
      table.insert(segments, { Foreground = { Color = colors.battery.bg } })
      table.insert(segments, { Text = SOLID_LEFT_ARROW })
      table.insert(segments, { Background = { Color = colors.battery.bg } })
      table.insert(segments, { Foreground = { Color = colors.battery.fg } })
      table.insert(segments, { Text = " " .. battery_info .. " " })
      prev_bg = colors.battery.bg
    end

    -- Music segment
    if music_info ~= "" then
      table.insert(segments, { Background = { Color = prev_bg } })
      table.insert(segments, { Foreground = { Color = colors.music.bg } })
      table.insert(segments, { Text = SOLID_LEFT_ARROW })
      table.insert(segments, { Background = { Color = colors.music.bg } })
      table.insert(segments, { Foreground = { Color = colors.music.fg } })
      table.insert(segments, { Text = " " .. music_info .. " " })
      prev_bg = colors.music.bg
    end

    -- Time segment
    table.insert(segments, { Background = { Color = prev_bg } })
    table.insert(segments, { Foreground = { Color = colors.time.bg } })
    table.insert(segments, { Text = SOLID_LEFT_ARROW })
    table.insert(segments, { Background = { Color = colors.time.bg } })
    table.insert(segments, { Foreground = { Color = colors.time.fg } })
    table.insert(segments, { Text = " " .. time .. " " })

    window:set_right_status(wezterm.format(segments))
  end)
end

return M
