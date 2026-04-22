{ pkgs, username, ... }: {
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
    ];

    casks = [
      # Terminal & shell adjacent
      "ghostty"

      # Window management & input
      # aerospace is installed via nixpkgs (see home.nix programs.aerospace).
      "karabiner-elements"
      "homerow"

      # Browsers
      "firefox"
      "google-chrome"
      "zen"

      # Comms
      "claude"
      "slack"
      "signal"
      "microsoft-teams"
      "zoom"

      # Media / creative
      "spotify"
      "obs"

      # Dev
      "visual-studio-code"

      # System / drivers
      "displaylink"
      "nordlayer"
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
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    screencapture.location = "~/Desktop";
  };

  system.stateVersion = 5;
}
