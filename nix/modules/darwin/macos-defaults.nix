{ user, ... }:

{
  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 25;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
    };

    dock = {
      autohide = true;
      tilesize = 16;
      mru-spaces = false;
      # ホットコーナー（左下・右下 → Mission Control）
      wvous-bl-corner = 2;
      wvous-br-corner = 2;
    };

    finder = {
      ShowPathbar = true;
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };

    trackpad = {
      Clicking = false;
      TrackpadThreeFingerDrag = false;
    };

    LaunchServices = {
      LSQuarantine = false;
    };

    screencapture = {
      location = "~/Downloads/_screenshot";
    };

    CustomUserPreferences = {
      "com.apple.finder" = {
        FXDefaultSearchScope = "SCcf";
        NewWindowTarget = "PfDe";
        NewWindowTargetPath = "file:///Users/${user}/";
      };
      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadThreeFingerVertSwipeGesture = 2;
      };
      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
      };
      "com.apple.dock" = {
        autohide-time-modifier = 0.1;
        autohide-delay = 0.1;
      };
      "com.apple.screencapture" = {
        location = "~/Downloads/_screenshot";
      };
      "com.apple.menuextra.battery" = {
        ShowPercent = "YES";
      };
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # (無効) Dock を自動的に表示/非表示
          "52" = { enabled = false; };
          # (無効) 前の入力ソースを選択
          "60" = { enabled = false; };
          # (無効) 次の入力ソースを選択
          "61" = { enabled = false; };
          # (無効) Spotlight
          "64" = { enabled = false; };
          # (無効) スクリーンショット: Cmd+Shift+3 (全画面をファイルに保存)
          "28" = { enabled = false; };
          # (無効) スクリーンショット: Ctrl+Cmd+Shift+3 (全画面をクリップボードへ)
          "29" = { enabled = false; };
          # (無効) スクリーンショット: Cmd+Shift+4 (選択範囲をファイルに保存)
          "30" = { enabled = false; };
          # (無効) スクリーンショット: Ctrl+Cmd+Shift+4 (選択範囲をクリップボードへ)
          "31" = { enabled = false; };
          # (無効) スクリーンショット: Cmd+Shift+5 (スクリーンショットオプション)
          "184" = { enabled = false; };
          # (無効) Finder 検索ウィンドウ: Cmd+Shift+Space
          "65" = { enabled = false; };
        };
      };
      NSGlobalDomain = {
        NSUserKeyEquivalents = {
          # いい感じ変換 → F12 (for azooKey)
          "いい感じ変換" = builtins.fromJSON ''"\uF70F"'';
          "いい感じ変換（無効/バックエンドなし）" = builtins.fromJSON ''"\uF70F"'';
        };
        # メニューバー間隔
        NSStatusItemSpacing = 8;
        NSStatusItemSelectionPadding = 6;
      };
    };

    CustomSystemPreferences = { };
  };
}
