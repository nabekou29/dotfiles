local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- モジュールローカル状態
local prev_workspace = nil
local pending_restore = {}
local pending_startup_confirm = false -- gui-startup でのみ true にする
local resurrect -- setup() で初期化

local ZOXIDE_PATH = (function()
  local candidates = {
    "/etc/profiles/per-user/" .. (os.getenv("USER") or "") .. "/bin/zoxide",
    "/opt/homebrew/bin/zoxide",
    "/usr/local/bin/zoxide",
  }
  for _, p in ipairs(candidates) do
    local f = io.open(p, "r")
    if f then
      f:close()
      return p
    end
  end
  return "zoxide"
end)()
local ZOXIDE_MAX_RESULTS = 50

--- 現在のワークスペース状態を保存する
local function save_current_workspace()
  resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
end

--- ワークスペースを復元する
local function restore_workspace(mux_window, name)
  local state = resurrect.state_manager.load_state(name, "workspace")
  if state then
    resurrect.workspace_state.restore_workspace(state, {
      window = mux_window,
      relative = true,
      restore_text = true,
      resize_window = false,
      on_pane_restore = resurrect.tab_state.default_on_pane_restore,
      close_open_tabs = true,
      close_open_panes = true,
    })
  end
end

--- 保存してからワークスペースを切り替える
local function save_and_switch(window, pane, target_name, target_cwd)
  local current_name = window:active_workspace()
  if current_name == target_name then
    return
  end

  prev_workspace = current_name
  save_current_workspace()

  -- 既存ワークスペースかチェック
  local existing = false
  for _, name in ipairs(wezterm.mux.get_workspace_names()) do
    if name == target_name then
      existing = true
      break
    end
  end

  local switch_opts = { name = target_name }
  if target_cwd and not existing then
    switch_opts.spawn = { cwd = target_cwd }
  end

  -- 新規ワークスペースの場合は復元をスケジュール
  if not existing then
    pending_restore[target_name] = true
  end

  window:perform_action(act.SwitchToWorkspace(switch_opts), pane)
end

--- InputSelector の choices を構築する
local function build_choices(window)
  local choices = {}
  local current = window:active_workspace()
  local existing_names = {}

  -- セクション 1: アクション
  table.insert(choices, {
    id = "action:rename",
    label = wezterm.format({
      { Foreground = { Color = "#e0af68" } },
      { Text = "  Rename workspace (" .. current .. ")" },
    }),
  })
  table.insert(choices, {
    id = "action:new",
    label = wezterm.format({
      { Foreground = { Color = "#9ece6a" } },
      { Text = "  New workspace" },
    }),
  })

  -- セクション 2: 既存ワークスペース
  for _, name in ipairs(wezterm.mux.get_workspace_names()) do
    existing_names[name] = true
    local is_current = (name == current)
    local suffix = is_current and " *" or ""
    local color = is_current and "#7aa2f7" or "#c0caf5"
    table.insert(choices, {
      id = "workspace:" .. name,
      label = wezterm.format({
        { Foreground = { Color = color } },
        { Attribute = { Intensity = is_current and "Bold" or "Normal" } },
        { Text = "󱂬  " .. name .. suffix },
      }),
    })
  end

  -- セクション 3: Zoxide ディレクトリ
  local ok, success, stdout = pcall(wezterm.run_child_process, { ZOXIDE_PATH, "query", "-ls" })
  if ok and success then
    local home = os.getenv("HOME") or ""
    local count = 0
    for line in stdout:gmatch("[^\r\n]+") do
      if count >= ZOXIDE_MAX_RESULTS then
        break
      end
      local _, path = line:match("^%s*([%d.]+)%s+(.+)$")
      if path then
        local basename = path:match("([^/]+)$")
        if basename and not existing_names[basename] then
          local short_path = path:gsub("^" .. home, "~")
          table.insert(choices, {
            id = "zoxide:" .. path,
            label = wezterm.format({
              { Foreground = { Color = "#c0caf5" } },
              { Text = "  " .. basename },
              { Foreground = { Color = "#565f89" } },
              { Text = "  " .. short_path },
            }),
          })
          count = count + 1
        end
      end
    end
  end

  return choices
end

--- 起動時の復元確認を表示する
local function show_startup_restore(window, pane)
  -- resurrect の fuzzy_loader で保存済み状態を選択して復元
  resurrect.fuzzy_loader.fuzzy_load(window, pane, function(id)
    local type = string.match(id, "^([^/]+)")
    id = string.match(id, "([^/]+)$")
    id = string.match(id, "(.+)%..+$")
    local opts = {
      window = window:mux_window(),
      relative = true,
      restore_text = true,
      resize_window = false,
      on_pane_restore = resurrect.tab_state.default_on_pane_restore,
      close_open_tabs = true,
      close_open_panes = true,
    }
    if type == "workspace" then
      local state = resurrect.state_manager.load_state(id, "workspace")
      resurrect.workspace_state.restore_workspace(state, opts)
    elseif type == "window" then
      local state = resurrect.state_manager.load_state(id, "window")
      resurrect.window_state.restore_window(window:mux_window(), state, opts)
    elseif type == "tab" then
      local state = resurrect.state_manager.load_state(id, "tab")
      resurrect.tab_state.restore_tab(pane:tab(), state, opts)
    end
  end, {
    title = "Restore previous session?",
    description = "Select a saved state to restore, or press Escape to start fresh.",
    fuzzy_description = "Search saved states: ",
    ignore_tabs = true,
  })
end

function M.setup()
  -- プラグインのロード
  resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

  ---- resurrect 設定 ----
  resurrect.state_manager.set_max_nlines(3000)
  resurrect.state_manager.periodic_save({
    interval_seconds = 300,
    save_workspaces = true,
    save_windows = true,
    save_tabs = false,
  })

  ---- gui-startup: 起動時復元確認のフラグを立てる ----
  wezterm.on("gui-startup", function(cmd)
    local _, _, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()
    pending_startup_confirm = true
  end)

  ---- update-status: pending_restore と起動時確認の処理 ----
  wezterm.on("update-status", function(window, pane)
    -- 起動時の復元確認
    if pending_startup_confirm then
      pending_startup_confirm = false
      show_startup_restore(window, pane)
      return
    end

    -- 新規ワークスペース作成後の復元
    local ws = window:active_workspace()
    if pending_restore[ws] then
      pending_restore[ws] = nil
      restore_workspace(window:mux_window(), ws)
    end
  end)

end

---- アクション定義 ----
-- setup() でプラグインが初期化された後にキー押下で呼ばれるため、resurrect は常に有効

M.actions = {
  --- 統合ワークスペーススイッチャー
  workspace_switcher = wezterm.action_callback(function(window, pane)
    local choices = build_choices(window)

    window:perform_action(
      act.InputSelector({
        title = "Workspace",
        choices = choices,
        fuzzy = true,
        fuzzy_description = "Switch, create, or rename workspace: ",
        action = wezterm.action_callback(function(inner_window, inner_pane, id)
          if not id then
            return
          end

          if id == "action:rename" then
            local current = inner_window:active_workspace()
            inner_window:perform_action(
              act.PromptInputLine({
                description = wezterm.format({
                  { Attribute = { Intensity = "Bold" } },
                  { Foreground = { Color = "#e0af68" } },
                  { Text = "Rename '" .. current .. "' to: " },
                }),
                action = wezterm.action_callback(function(prompt_window, prompt_pane, line)
                  if line and line ~= "" then
                    wezterm.mux.rename_workspace(prompt_window:active_workspace(), line)
                  end
                end),
              }),
              inner_pane
            )
          elseif id == "action:new" then
            inner_window:perform_action(
              act.PromptInputLine({
                description = wezterm.format({
                  { Attribute = { Intensity = "Bold" } },
                  { Foreground = { Color = "#9ece6a" } },
                  { Text = "New workspace name: " },
                }),
                action = wezterm.action_callback(function(prompt_window, prompt_pane, line)
                  if line and line ~= "" then
                    save_current_workspace()
                    prev_workspace = prompt_window:active_workspace()
                    pending_restore[line] = true
                    prompt_window:perform_action(act.SwitchToWorkspace({ name = line }), prompt_pane)
                  end
                end),
              }),
              inner_pane
            )
          elseif id:match("^workspace:") then
            local name = id:gsub("^workspace:", "")
            save_and_switch(inner_window, inner_pane, name, nil)
          elseif id:match("^zoxide:") then
            local path = id:gsub("^zoxide:", "")
            local name = path:match("([^/]+)$")
            save_and_switch(inner_window, inner_pane, name, path)
          end
        end),
      }),
      pane
    )
  end),

  --- 次のワークスペースへ (自動保存付き)
  switch_next = wezterm.action_callback(function(window, pane)
    prev_workspace = window:active_workspace()
    save_current_workspace()
    window:perform_action(act.SwitchWorkspaceRelative(1), pane)
  end),

  --- 前のワークスペースへ (自動保存付き)
  switch_prev = wezterm.action_callback(function(window, pane)
    prev_workspace = window:active_workspace()
    save_current_workspace()
    window:perform_action(act.SwitchWorkspaceRelative(-1), pane)
  end),

  --- 直前のワークスペースに戻る
  switch_previous = wezterm.action_callback(function(window, pane)
    if prev_workspace then
      local current = window:active_workspace()
      save_current_workspace()
      local target = prev_workspace
      prev_workspace = current
      window:perform_action(act.SwitchToWorkspace({ name = target }), pane)
    end
  end),

  --- ワークスペース手動保存
  save = wezterm.action_callback(function()
    save_current_workspace()
  end),

  --- 保存状態の fuzzy 復元
  fuzzy_restore = wezterm.action_callback(function(win, pane)
    resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
      local type = string.match(id, "^([^/]+)")
      id = string.match(id, "([^/]+)$")
      id = string.match(id, "(.+)%..+$")
      local opts = {
        window = win:mux_window(),
        relative = true,
        restore_text = true,
        resize_window = false,
        on_pane_restore = resurrect.tab_state.default_on_pane_restore,
        close_open_tabs = true,
        close_open_panes = true,
      }
      if type == "workspace" then
        local state = resurrect.state_manager.load_state(id, "workspace")
        resurrect.workspace_state.restore_workspace(state, opts)
      elseif type == "window" then
        local state = resurrect.state_manager.load_state(id, "window")
        resurrect.window_state.restore_window(win:mux_window(), state, opts)
      elseif type == "tab" then
        local state = resurrect.state_manager.load_state(id, "tab")
        resurrect.tab_state.restore_tab(pane:tab(), state, opts)
      end
    end)
  end),
}

return M
