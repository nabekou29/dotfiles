{ ... }:

{
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
      "k1LoW/tap"
      "ngrok/ngrok"
      "neurosnap/tap"
      "tonisives/tap"
    ];

    brews = [
      "k1LoW/tap/mo"
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
      # "deskflow" # brew に存在しない
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
      "Hidden Bar" = 1452453066;
      "Klack" = 6446206067;
      "Xcode" = 497799835;
    };
  };
}
