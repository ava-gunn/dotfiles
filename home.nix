{ pkgs, lib, config, username, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
in {
  home = {
    stateVersion = "24.05";
    username = username;
    homeDirectory = "/Users/${username}";

    sessionVariables = {
      EDITOR = "nvim";
      BAT_THEME = "tokyonight_night";
      ZLE_RPROMPT_INDENT = "4";
    };

    packages = with pkgs; [
      # Dev toolchains
      ast-grep
      bash
      bun
      cocoapods
      emacs
      exercism
      ffmpeg
      fnm
      gh
      lazygit
      leiningen
      htop
      luaPackages.fennel
      neovim
      nixfmt
      rustup
      tree-sitter

      # Utilities
      less
      speedtest-cli
      tldr
      tree
      wget
    ];
  };

  xdg.enable = true;
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = config.home.homeDirectory;

    history = {
      size = 5000;
      save = 5000;
      share = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    shellAliases = {
      ls = "eza --color=always --icons";
      la = "ls -la";
      c = "clear";
      vim = "nvim";
      vi = "nvim";
      cat = "bat";
      "綺麗に" = "clear";
      "家" = "cd ~";
      "物" = "cd ~/Developer/monorepo/";
      "ヴィ" = "vim";
      vimconfig = "vim ~/.config/nvim/init.lua";
      zshconfig = "vim ~/.zshrc && source ~/.zshrc";
      gr = "grep -Fr --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=.next --exclude-dir=.git --exclude-dir=.turbo --exclude-dir=out --exclude-dir=playwright-report --exclude-dir=design-system";
      ccs = "codecrafters";
      portkill = "killport";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "command-not-found" ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Powerlevel10k instant prompt — must run before plugins produce output.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
        typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

        if [[ -f "/opt/homebrew/bin/brew" ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      '')

      ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        bindkey -e
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward
        bindkey '^[w' kill-region

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

        mdn() { open "https://developer.mozilla.org/en-US/search?q=$@"; }

        _fzf_comprun() {
          local command=$1
          shift
          case "$command" in
            cd)   fzf "$@" --preview 'tree -C {} | head -200' ;;
            ls)   fzf "$@" --preview 'tree -C {} | head -200' ;;
            cat)  fzf "$@" --preview 'bat --style=numbers --color=always --line-range :500 {}' ;;
            vim)  fzf "$@" --preview 'bat --style=numbers --color=always --line-range :500 {}' ;;
            *)    fzf "$@" ;;
          esac
        }

        # fnm replaces nvm, but keep the auto-switch-on-cd behaviour.
        if command -v fnm >/dev/null; then
          eval "$(fnm env --use-on-cd --shell zsh)"
        fi

        # Herd (PHP) — only if installed.
        if [ -d "$HOME/Library/Application Support/Herd" ]; then
          export PATH="$HOME/Library/Application Support/Herd/bin:$PATH"
          export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"
          export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"
          export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
        fi

        [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
        [ -d "$HOME/.bun/bin" ] && export PATH="$HOME/.bun/bin:$PATH"
        export PATH="$HOME/.local/bin:$PATH"
      ''
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    # Aliases are handled manually in programs.zsh.shellAliases to keep
    # the original `ls = eza --color=always --icons` behaviour.
    enableZshIntegration = false;
  };

  programs.fd = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    config.theme = "tokyonight_night";
    themes.tokyonight_night = {
      src = ./.config/bat/themes;
      file = "tokyonight_night.tmTheme";
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      opener.edit = [{ run = ''nvim "$@"''; block = true; }];
      manager.ratio = [ 1 3 4 ];
      preview.max_width = 2500;
    };
  };

  programs.lazygit = {
    enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "ava-gunn_noa";
      user.email = "avagu001@noa.nintendo.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    ignores = [
      ".DS_Store"
      "*.swp"
      ".direnv"
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      version = 1;
      git_protocol = "https";
      editor = "vim";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
  };

  # Ghostty: Homebrew cask (nixpkgs build is Linux-only).
  programs.ghostty = {
    enable = true;
    package = null;
    # Ghostty auto-injects shell integration via ZDOTDIR; enabling it here
    # adds a redundant source in ~/.zshrc that loads AFTER powerlevel10k
    # and corrupts the p10k Pure-style prompt (stray "}}" before ❯).
    enableZshIntegration = false;
    installVimSyntax = false;
    settings = {
      theme = "TokyoNight Moon";
      font-family = "MesloLGS NF";
      font-size = 17;
      font-feature = "-liga";
      font-thicken = false;
      background = "#222334";
      window-padding-x = 12;
      window-padding-y = 12;
      background-opacity = 0.9;
      background-blur = 20;
      macos-titlebar-style = "hidden";
    };
  };

  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      after-login-command = [ ];
      after-startup-command = [
        "exec-and-forget brew services start sketchybar"
      ];
      start-at-login = true;
      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      key-mapping.preset = "qwerty";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = 10;
        outer.bottom = 10;
        outer.top = 50;
        outer.right = 10;
      };

      mode.main.binding = {
        alt-shift-f = "layout floating";
        alt-shift-t = "layout tiling";
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        alt-h = "focus left --boundaries all-monitors-outer-frame --boundaries-action stop";
        alt-j = "focus down --boundaries all-monitors-outer-frame --boundaries-action stop";
        alt-k = "focus up --boundaries all-monitors-outer-frame --boundaries-action stop";
        alt-l = "focus right --boundaries all-monitors-outer-frame --boundaries-action stop";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        alt-shift-1 = [ "move-node-to-workspace 1" "workspace 1" ];
        alt-shift-2 = [ "move-node-to-workspace 2" "workspace 2" ];
        alt-shift-3 = [ "move-node-to-workspace 3" "workspace 3" ];
        alt-shift-4 = [ "move-node-to-workspace 4" "workspace 4" ];
        alt-shift-5 = [ "move-node-to-workspace 5" "workspace 5" ];
        alt-shift-6 = [ "move-node-to-workspace 6" "workspace 6" ];
        alt-shift-7 = [ "move-node-to-workspace 7" "workspace 7" ];
        alt-shift-8 = [ "move-node-to-workspace 8" "workspace 8" ];
        alt-shift-9 = [ "move-node-to-workspace 9" "workspace 9" ];

        alt-tab = "workspace-back-and-forth";
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
        alt-shift-semicolon = "mode service";

        alt-shift-p = [
          "exec-and-forget osascript -e 'display notification \"Aerospace shortcuts disabled\" with title \"Passthrough ON\"'"
          "mode passthrough"
        ];
      };

      mode.passthrough.binding = {
        alt-shift-p = [
          "exec-and-forget osascript -e 'display notification \"Aerospace shortcuts active\" with title \"Passthrough OFF\"'"
          "mode main"
        ];
      };

      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];

        alt-shift-h = [ "join-with left" "mode main" ];
        alt-shift-j = [ "join-with down" "mode main" ];
        alt-shift-k = [ "join-with up" "mode main" ];
        alt-shift-l = [ "join-with right" "mode main" ];
      };

      workspace-to-monitor-force-assignment = {
        "1" = "main";
        "2" = "main";
        "3" = "main";
        "4" = "main";
        "5" = "main";
        "6" = "main";
        "7" = "secondary";
        "8" = "secondary";
        "9" = "secondary";
      };
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    prefix = "C-Space";
    baseIndex = 1;
    escapeTime = 0;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
      tokyo-night-tmux
      {
        plugin = tmux-floax;
        extraConfig = ''
          set -g @floax-bind 'f'
          set -g @floax-width '50%'
          set -g @floax-height '80%'
        '';
      }
      tmux-which-key
    ];

    extraConfig = ''
      set-option -sa terminal-overrides ",xterm*:Tc"

      set -g @tokyo-night-tmux_window_id_style hsquare
      set -g @tokyo-night-tmux_pane_id_style hsquare
      set -g @tokyo-night-tmux_zoom_id_style dsquare

      setw -g pane-base-index 1
      set-option -g status-position top

      # Smart pane switching with awareness of Vim splits.
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      bind-key -n 'C-\' if-shell "$is_vim" 'send-keys C-\\' 'select-pane -l'

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      # Image passthrough (for sixel/kitty graphics in tmux).
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };

  home.file.".p10k.zsh".source = ./.p10k.zsh;

  # Mutable-symlink dirs. Tools rewrite files here in place (LazyVim's
  # lazy-lock.json, htop's htoprc), so plain home.file would break on rewrite.
  home.activation.linkMutableConfigDirs =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      link() {
        if [ -e "$2" ] && [ ! -L "$2" ]; then
          echo "home-manager: $2 is not a symlink, skipping"
          return
        fi
        run --silence ln -sfn "$1" "$2"
      }
      run --silence mkdir -p "$HOME/.config"
      link "${dotfilesDir}/.config/nvim" "$HOME/.config/nvim"
      link "${dotfilesDir}/.config/htop" "$HOME/.config/htop"
      link "${dotfilesDir}/.config/sketchybar" "$HOME/.config/sketchybar"
    '';
}
