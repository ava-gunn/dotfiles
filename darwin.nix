{ pkgs, username, ... }:
{
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  # Determinate Nix manages the daemon itself; nix-darwin must not touch it.
  # Flakes and nix-command are already enabled by the Determinate installer.
  nix.enable = false;

  # Declares the primary user so nix-darwin can apply user-level defaults.
  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  # Make zsh the default shell.
  programs.zsh.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.meslo-lg
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];

    brews = [
      "svim"
      "sketchybar"
    ];

    casks = [
      "ghostty"
      "karabiner-elements"
      "homerow"
      "firefox"
      "google-chrome"
      "zen"
      "claude"
      "slack"
      "signal"
      "microsoft-teams"
      "zoom"
      "spotify"
      "obs"
      "visual-studio-code"
      "nordlayer"
      "font-hack-nerd-font"
      "sf-symbols"
    ];
  };

  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      mru-spaces = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
      FXPreferredViewStyle = "Nlsv";
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      AppleInterfaceStyle = "Dark";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      ApplePressAndHoldEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      _HIHideMenuBar = true;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    screencapture.location = "~/Desktop";
  };

  system.stateVersion = 5;
}
