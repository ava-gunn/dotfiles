{ pkgs, ... }: {
  home = {
    stateVersion = "24.05";
    username = "ava";
    homeDirectory = "/Users/ava";
    packages = [
      pkgs.git
      pkgs.neovim
      pkgs.tmux
      pkgs.stow
      pkgs.bat
      pkgs.tree
      pkgs.fzf
      pkgs.zoxide
      pkgs.eza
      pkgs.fd
      pkgs.less
      pkgs.karabiner-elements
      pkgs.rustup
      pkgs.yazi

      pkgs.ast-grep
      pkgs.bash
      pkgs.cocoapods
      pkgs.emacs
      pkgs.exercism
      pkgs.luaPackages.fennel
      pkgs.ffmpeg
      pkgs.htop
      pkgs.lazygit
      pkgs.leiningen
      pkgs.nixfmt-rfc-style
      pkgs.speedtest-cli
      pkgs.tldr
      pkgs.tree-sitter
      pkgs.wget
    ];
  };
  xdg.enable = true;
  programs.home-manager.enable = true;
}
