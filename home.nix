{ pkgs, ... }: {
  home = {
    stateVersion = "24.05";
    username = "ava";
    homeDirectory = "/Users/ava";
    packages = [
      pkgs.bash
      pkgs.lua
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
      pkgs.aerospace
      pkgs.karabiner-elements
      # pkgs.raycast
      pkgs.rustup
      pkgs.yazi
      pkgs.jdk
      pkgs.clojure
      pkgs.leiningen
      pkgs.babashka
      pkgs.janet
      pkgs.jpm
    ];
  };
  xdg.enable = true;
  programs.home-manager.enable = true;
}

# Non nix pkgs
# svim https://github.com/FelixKratz/SketchyVim
# brew tap FelixKratz/formulae
# brew install svim
# brew services start svim
# Homerow
