{ pkgs, ... }: {
  home = {
    stateVersion = "23.11";
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
      pkgs.alacritty
      pkgs.fd
      pkgs.less
      pkgs.gh
      pkgs.mpw
      pkgs.karabiner-elements
      pkgs.rustup
      pkgs.yazi
    ];
  };
  xdg.enable = true;
  programs.home-manager.enable = true;
}
