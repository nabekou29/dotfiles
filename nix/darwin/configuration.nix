{ pkgs, user, ... }:

{
  # Determinate Nix が Nix デーモンを管理するため無効化
  nix.enable = false;

  system.primaryUser = user;
  system.stateVersion = 6;

  # macOS defaults
  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 25;
      ApplePressAndHoldEnabled = false;
    };

    dock = {
      autohide = true;
      tilesize = 16;
    };

    finder = {
      ShowPathbar = true;
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
        };
      };
      NSGlobalDomain = {
        NSUserKeyEquivalents = {
          # いい感じ変換 → F12 (for azooKey)
          "いい感じ変換" = "\\UF70F";
          "いい感じ変換（無効/バックエンドなし）" = "\\UF70F";
        };
        # メニューバー間隔
        NSStatusItemSpacing = 8;
        NSStatusItemSelectionPadding = 6;
      };
    };

    CustomSystemPreferences = {};
  };

  # Homebrew (brew, cask, mas)
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # cleanup = "zap"; # 宣言されていないパッケージを削除（慎重に有効化）
    };

    taps = [
      "homebrew/bundle"
      "1password/tap"
      "ngrok/ngrok"
      "neurosnap/tap"
    ];

    brews = [
      "media-control"
      "neurosnap/tap/zmx"
      "tfenv"
    ];

    casks = [
      # Terminal
      "wezterm@nightly"

      # Fonts
      "font-fira-code-nerd-font"
      "font-hackgen"
      "font-hackgen-nerd"
      "font-monaspace"
      "font-moralerspace"

      # Utility
      "1password"
      "1password-cli"
      "alfred"
      "alt-tab"
      "deskpad"
      "google-japanese-ime"
      "karabiner-elements"
      "keycastr"
      "logi-options+"
      "mac-mouse-fix"
      "monitorcontrol"
      "obsidian"
      "raycast"
      "setapp"

      # Browser
      "firefox"
      "google-chrome"

      # Development
      "android-platform-tools"
      "android-studio"
      "claude"
      "claude-code"
      "figma"
      "google-cloud-sdk"

      # IDE / Editor
      "visual-studio-code"

      # Other Apps
      "chatgpt"
      "ngrok"

      # Quick Look
      "apparency"
      "qlcolorcode"
      "qlimagesize"
      "qlmarkdown"
      "qlstephen"
      "qlvideo"
      "quicklook-json"
      "quicklookase"
      "suspicious-package"
    ];

    masApps = {
      "Display Menu" = 549083868;
      "Hidden Bar" = 1452453066;
      "Klack" = 6446206067;
      "Xcode" = 497799835;
    };
  };
}
