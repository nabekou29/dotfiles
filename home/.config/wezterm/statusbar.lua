-- ステータスバー（旧 tabline.lua の update-status を忠実に踏襲）
-- workspace/zoom 表示は herdr に委譲するため省く。
-- jq 依存 → wezterm.json_parse に置換。git/music はキャッシュ。
local M = {}

local MEDIA_CONTROL = "/opt/homebrew/bin/media-control"
local BASE_BG = "#15161e" -- 旧 tb_color.background

-- 右ステータスの配色（旧実装そのまま）
local rc = {
  git     = { bg = "#1d2541", fg = "#84a0c6" },
  cwd     = { bg = "#263156", fg = "#89b8c2" },
  battery = { bg = "#374478", fg = "#b4be82" },
  music   = { bg = "#3f4e8b", fg = "#e27878" },
  time    = { bg = "#4962af", fg = "#c6c8d1" },
}


-- バッテリーアイコン（旧実装の glyph をそのまま踏襲）
local BATTERY_ICONS = {
  charging = utf8.char(0xEE9E),
  full     = utf8.char(0xF240),
  high     = utf8.char(0xF241),
  mid      = utf8.char(0xF242),
  low      = utf8.char(0xF243),
  empty    = utf8.char(0xF244),
}

local function battery_icon(state, charge)
  if state == "Charging"  then return BATTERY_ICONS.charging
  elseif charge > 90      then return BATTERY_ICONS.full
  elseif charge > 75      then return BATTERY_ICONS.high
  elseif charge > 50      then return BATTERY_ICONS.mid
  elseif charge > 25      then return BATTERY_ICONS.low
  else                         return BATTERY_ICONS.empty
  end
end

-- cwd の整形（旧実装と同じ: ~ 短縮 + 末尾2階層）
local function format_cwd(pane)
  local uri = pane:get_current_working_dir()
  if not uri then return nil end
  local path = uri.file_path
  if not path then return nil end
  local home = os.getenv("HOME")
  if home then path = path:gsub("^" .. home, "~") end
  local parts = {}
  for part in path:gmatch("[^/]+") do table.insert(parts, part) end
  if #parts > 2 then
    path = "…/" .. parts[#parts - 1] .. "/" .. parts[#parts]
  end
  return path
end

-- git ブランチ（cwd 単位で 5 秒キャッシュ）
local function get_git_branch(wezterm, pane)
  local uri = pane:get_current_working_dir()
  if not uri or not uri.file_path then return "" end
  local cwd = uri.file_path
  local now = os.time()
  local cache = wezterm.GLOBAL.git_cache or {}
  local entry = cache[cwd]
  if entry and (now - entry.ts) < 5 then return entry.branch end
  local branch = ""
  local ok, stdout = wezterm.run_child_process({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" })
  if ok then branch = stdout:gsub("%s+", "") end
  cache[cwd] = { branch = branch, ts = now }
  wezterm.GLOBAL.git_cache = cache
  return branch
end

-- 音楽（旧実装の挙動: 再生中→曲名、それ以外→󰝛。3 秒キャッシュ）
-- jq の代わりに wezterm.json_parse を使う
local MUSIC_PLAYING_ICON = utf8.char(0xEC1B)

local function get_music(wezterm)
  local now = os.time()
  if wezterm.GLOBAL.music_ts and (now - wezterm.GLOBAL.music_ts) < 3 then
    return wezterm.GLOBAL.music_text or ""
  end
  local text = wezterm.nerdfonts.md_music_off or ""
  pcall(function()
    local ok, stdout = wezterm.run_child_process({ MEDIA_CONTROL, "get", "-h" })
    if not ok then return end
    local data = wezterm.json_parse(stdout)
    if data and data.playing and data.title and data.title ~= "" then
      local s = MUSIC_PLAYING_ICON .. " " .. data.title
      if data.artist and data.artist ~= "" then s = s .. " - " .. data.artist end
      text = wezterm.truncate_right(s, 35)
    end
  end)
  wezterm.GLOBAL.music_text = text
  wezterm.GLOBAL.music_ts = now
  return text
end

function M.setup(wezterm, config)
  config.enable_tab_bar = true
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false
  config.hide_tab_bar_if_only_one_tab = false
  config.show_tab_index_in_tab_bar = false
  config.show_new_tab_button_in_tab_bar = false

  config.colors = config.colors or {}
  config.colors.tab_bar = {
    background = BASE_BG,
    active_tab          = { bg_color = "#7aa2f7", fg_color = "#15161e", intensity = "Bold" },
    inactive_tab        = { bg_color = "#292e42", fg_color = "#545c7e" },
    inactive_tab_hover  = { bg_color = "#3b4261", fg_color = "#c0caf5" },
    new_tab             = { bg_color = "#15161e", fg_color = "#7aa2f7" },
    new_tab_hover       = { bg_color = "#292e42", fg_color = "#7aa2f7" },
  }

  -- pl_right_hard_divider = U+E0B2 = ◀  → 右ステータス用（セグメントが左に伸びる）
  local ARROW_FOR_RIGHT = wezterm.nerdfonts.pl_right_hard_divider  -- ◀

  -- タブタイトル（プロセス名）をタブバー背景色と同化させて非表示にする
  -- タブバー自体は right_status 表示のために必要なので hide ではなく透明化
  wezterm.on("format-tab-title", function()
    return {
      { Background = { Color = BASE_BG } },
      { Foreground = { Color = BASE_BG } },
      { Text = " " },
    }
  end)

  wezterm.on("update-status", function(window, pane)
    local cwd    = format_cwd(pane)
    local branch = get_git_branch(wezterm, pane)
    local music  = get_music(wezterm)
    local time   = wezterm.strftime("%H:%M")

    -- バッテリー
    local battery_str = ""
    for _, b in ipairs(wezterm.battery_info()) do
      local charge = math.floor(b.state_of_charge * 100)
      battery_str = string.format("%s  %d%%", battery_icon(b.state, charge), charge)
    end

    -- ============================================================
    -- 右ステータス: git → cwd → battery → music → time
    -- 旧実装の explicit element-by-element 方式をそのまま踏襲
    -- ============================================================
    local right = {}
    local prev_bg = BASE_BG

    local function push_right(color, text)
      table.insert(right, { Background = { Color = prev_bg } })
      table.insert(right, { Foreground = { Color = color.bg } })
      table.insert(right, { Text = ARROW_FOR_RIGHT })
      table.insert(right, { Background = { Color = color.bg } })
      table.insert(right, { Foreground = { Color = color.fg } })
      table.insert(right, { Text = text })
      prev_bg = color.bg
    end

    if branch ~= "" then push_right(rc.git, "  " .. branch .. " ") end
    if cwd         then push_right(rc.cwd, "  " .. cwd .. " ")     end
    if battery_str ~= "" then push_right(rc.battery, " " .. battery_str .. " ") end
    if music ~= "" then push_right(rc.music, " " .. music .. " ")  end
    push_right(rc.time, " " .. time .. " ")

    window:set_right_status(wezterm.format(right))
    window:set_left_status("")
  end)
end

return M
