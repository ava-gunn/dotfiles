{ pkgs, ... }: {
  home = {
    stateVersion = "24.05";
    username = "clark";
    homeDirectory = "/Users/clark";
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
      pkgs.mpw
      pkgs.karabiner-elements
      pkgs.rustup
      pkgs.yazi
      pkgs.hyfetch
    ];
  };
  xdg.enable = true;
  programs.home-manager.enable = true;
}
