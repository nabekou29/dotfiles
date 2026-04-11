{ pkgs, user, ... }:

{
  # Determinate Nix が Nix デーモンを管理するため無効化
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;

  system.primaryUser = user;
  system.stateVersion = 6;

  # Touch ID で sudo 認証
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS defaults
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
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-bl-modifier = 0;
      wvous-br-modifier = 0;
    };

    finder = {
      ShowPathbar = true;
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
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
          "いい感じ変換" = builtins.fromJSON ''"\uF70F"'';
          "いい感じ変換（無効/バックエンドなし）" = builtins.fromJSON ''"\uF70F"'';
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
      cleanup = "zap";
    };

    taps = [
      "homebrew/bundle"
      "1password/tap"
      "ngrok/ngrok"
      "neurosnap/tap"
      "tonisives/tap"
    ];

    brews = [
      "media-control"
      "neurosnap/tap/zmx"
      "tfenv"
    ];

    casks = [
      # Terminal
      "alacritty"
      "ghostty"
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
      # "azookey" # beta 版を手動管理中
      "deskflow"
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
      "docker-desktop"
      "figma"
      "gcloud-cli"

      # IDE / Editor
      "visual-studio-code"

      # Other Apps
      "chatgpt"
      "ngrok"
      "ovim"

      # Quick Look
      "apparency"
      "qlcolorcode"
      "qlimagesize"
      "qlmarkdown"
      "qlstephen"
      "quicklook-video"
      "quicklook-json"
      "quicklookase"
      "suspicious-package"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Display Menu" = 549083868;
      "Hidden Bar" = 1452453066;
      "Klack" = 6446206067;
      "Xcode" = 497799835;
    };
  };
}
