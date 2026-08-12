#!/bin/bash
# macOS defaults を宣言的に適用する
# 内容を変更すると chezmoi apply 時に再実行される
set -euo pipefail

echo "Applying macOS defaults ..."

# ---------- NSGlobalDomain ----------
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 25
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write -g AppleShowAllExtensions -bool true

# メニューバー間隔
defaults write -g NSStatusItemSpacing -int 8
defaults write -g NSStatusItemSelectionPadding -int 6

# マウス/トラックパッドの軌跡の速さ (0〜3, 最速=3)
defaults write -g com.apple.mouse.scaling -float 3.0
defaults write -g com.apple.trackpad.scaling -float 3.0
# スクロールの速さ (システム設定のスライダー相当: 0.125〜7, デフォルト=0.75)
defaults write -g com.apple.scrollwheel.scaling -float 0.3125

# いい感じ変換 → F12 (for azooKey)  ※ \xef\x9c\x8f = U+F70F (F12)
defaults write -g NSUserKeyEquivalents -dict-add "いい感じ変換" "$(printf '\xef\x9c\x8f')"
defaults write -g NSUserKeyEquivalents -dict-add "いい感じ変換（無効/バックエンドなし）" "$(printf '\xef\x9c\x8f')"

# ---------- Dock ----------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 16
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock autohide-time-modifier -float 0.1
defaults write com.apple.dock autohide-delay -float 0.1
# ホットコーナー（左下・右下 → Mission Control）
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0

# ---------- Finder ----------
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/"

# ---------- Trackpad ----------
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false
# 3本指の縦スワイプ → Mission Control
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2

# ---------- LaunchServices ----------
defaults write com.apple.LaunchServices LSQuarantine -bool false

# ---------- Screenshot ----------
mkdir -p "$HOME/Downloads/_screenshot"
defaults write com.apple.screencapture location -string "$HOME/Downloads/_screenshot"

# ---------- メニューバー時計 ----------
defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true
defaults write com.apple.menuextra.clock FlashDateSeparators -bool true

# ---------- バッテリー ----------
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# ---------- ネットワークボリュームに .DS_Store を作らない ----------
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# ---------- キーボードショートカット無効化 ----------
# 52: Dock 自動表示/非表示, 60/61: 入力ソース切替, 64: Spotlight, 65: Finder 検索
# 28/29/30/31/184: スクリーンショット各種
for key in 52 60 61 64 65 28 29 30 31 184; do
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$key" \
    "<dict><key>enabled</key><false/></dict>"
done

# ---------- Ice (メニューバー管理) ----------
defaults write com.jordanbaird.Ice SUEnableAutomaticChecks -bool false
defaults write com.jordanbaird.Ice SUAutomaticallyUpdate -bool false
defaults write com.jordanbaird.Ice SUSendProfileInfo -bool false
# Ice Bar (ポップアップ式メニューバー) を使用
defaults write com.jordanbaird.Ice UseIceBar -bool true
defaults write com.jordanbaird.Ice IceBarLocation -int 2
# 常時非表示セクションを有効化
defaults write com.jordanbaird.Ice EnableAlwaysHiddenSection -bool true
defaults write com.jordanbaird.Ice ShowAllSectionsOnUserDrag -bool true
# アプリメニューを隠す
defaults write com.jordanbaird.Ice HideApplicationMenus -bool true
# 自動再非表示
defaults write com.jordanbaird.Ice AutoRehide -bool true
defaults write com.jordanbaird.Ice RehideStrategy -int 0
defaults write com.jordanbaird.Ice RehideInterval -int 15

# ---------- 反映 ----------
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u || true
killall Dock 2>/dev/null || true
killall Finder 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "macOS defaults applied."
