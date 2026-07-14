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
      "blackhole-2ch"
      "nordlayer"
      "font-hack-nerd-font"
      "sf-symbols"
    ];
  };

  # Homebrew refuses to load formulae from third-party taps (e.g. svim,
  # sketchybar from FelixKratz/formulae) unless the tap is trusted. `brew trust`
  # writes to $XDG_CONFIG_HOME/homebrew/trust.json, but nix-darwin runs
  # `brew bundle` with a scrubbed env (only PATH preserved), so XDG_CONFIG_HOME
  # is unset and brew reads the fallback ~/.homebrew/trust.json — which is empty.
  # Seed it here; preActivation runs (as root) before the homebrew step.
  system.activationScripts.preActivation.text = ''
    install -d -m 755 -o ${username} -g staff "/Users/${username}/.homebrew"
    printf '%s\n' '{"trustedtaps":["felixkratz/formulae"]}' > "/Users/${username}/.homebrew/trust.json"
    chown ${username}:staff "/Users/${username}/.homebrew/trust.json"
  '';

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
