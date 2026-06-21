{ ... }:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      # Homebrew 5.x で `brew bundle install --cleanup` に必須となったフラグ
      extraFlags = [ "--force-cleanup" ];
      # Homebrew 6.0 で tap trust がデフォルト強制になったが nix-darwin は未対応。
      # activation は sudo 下で走り user の trust.json が見えないため一時的に無効化。
      extraEnv = {
        HOMEBREW_NO_REQUIRE_TAP_TRUST = "1";
      };
    };

    taps = [
      "homebrew/bundle"
      "1password/tap"
      "k1LoW/tap"
      "ngrok/ngrok"
      "neurosnap/tap"
      "tonisives/tap"
      "vjeantet/tap"
    ];

    brews = [
      "k1LoW/tap/mo"
      "media-control"
      "neurosnap/tap/zmx"
      "tfenv"
      "vjeantet/tap/alerter"
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
      "activitywatch"
      "alfred"
      "alt-tab"
      "azookey"
      # "deskflow" # brew に存在しない
      "deskpad"
      "finetune"
      "google-japanese-ime"
      "jordanbaird-ice@beta"
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
      "zoom"

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
      "Klack" = 6446206067;
      "Xcode" = 497799835;
    };
  };
}
