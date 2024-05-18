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
    ];
  };
  xdg.enable = true;
  programs.home-manager.enable = true;
}
