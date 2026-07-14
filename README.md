# Dotfiles

macOS setup via [Nix flakes][flakes], [nix-darwin][nix-darwin], and [home-manager][hm].

[flakes]: https://nixos.wiki/wiki/Flakes
[nix-darwin]: https://github.com/LnL7/nix-darwin
[hm]: https://github.com/nix-community/home-manager

## Layout

| Path | Purpose |
|---|---|
| `flake.nix` | Flake inputs/outputs (`darwinConfigurations.ava`, `homeConfigurations.ava`) |
| `darwin.nix` | System: Homebrew casks, fonts, `system.defaults` |
| `home.nix` | User: shell, CLI, `programs.*` configs |
| `.config/nvim` | LazyVim, mutable symlink into `~/.config/nvim` |
| `.config/htop` | htoprc dir, mutable symlink into `~/.config/htop` |
| `.config/sketchybar` | Status bar config, mutable symlink into `~/.config/sketchybar` |
| `.config/karabiner` | Manually-synced backup (see below) |
| `.config/bat/themes` | TokyoNight theme read by `programs.bat` |
| `.p10k.zsh` | Powerlevel10k config, linked to `~/.p10k.zsh` |

## First-time setup

### 1. Nix
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Homebrew
```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. Clone
```sh
git clone https://github.com/<you>/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 4. Move colliding files aside
home-manager won't clobber existing files. Either delete them or:
```sh
for f in ~/.zshrc ~/.p10k.zsh ~/.config/ghostty/config ~/.config/tmux/tmux.conf \
         ~/.config/bat/config ~/.config/yazi/yazi.toml ~/.config/aerospace/aerospace.toml \
         ~/.config/git/config ~/.config/git/ignore ~/.config/gh/config.yml; do
  [ -e "$f" ] && [ ! -L "$f" ] && mv "$f" "$f.pre-nix"
done
for d in ~/.config/nvim ~/.config/htop ~/.config/sketchybar; do
  [ -e "$d" ] && [ ! -L "$d" ] && mv "$d" "$d.pre-nix"
done
```

Or pass `-b backup` to the switch command to auto-rename.

### 5. First switch
```sh
nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles#ava
```

No `sudo` — `darwin-rebuild` escalates internally.

### 6. Manual steps
- Grant Accessibility/Input Monitoring to: Karabiner, AeroSpace, Homerow
- Grant Screen Recording to: OBS
- `gh auth login`

## Ongoing

```sh
darwin-rebuild switch --flake ~/dotfiles#ava        # after any edit
home-manager switch --flake ~/dotfiles#ava          # user-only, faster
nix flake update && darwin-rebuild switch --flake ~/dotfiles#ava   # update inputs
darwin-rebuild switch --flake ~/dotfiles#ava --rollback             # undo
```

## Adding things

- CLI or darwin-packaged GUI → `home.packages` in `home.nix`
- `.app`-only GUI → `homebrew.casks` in `darwin.nix`
- macOS setting → `system.defaults` in `darwin.nix`
- Shell alias → `programs.zsh.shellAliases` in `home.nix`
- Raw config file → `home.file` / `xdg.configFile`
- Mutable in-repo config dir → add to `linkMutableConfigDirs` in `home.nix`

## Tool notes

- **LazyVim**: `.config/nvim` is a mutable symlink back to this repo. `lazy-lock.json` is committed — let LazyVim update it, then commit.
- **Karabiner**: rewrites `karabiner.json` atomically, which breaks symlinks, so it's not auto-linked. After meaningful changes, `cp ~/.config/karabiner/karabiner.json ~/dotfiles/.config/karabiner/`. On a fresh Mac, reverse the copy with Karabiner quit.
- **Ghostty**: Homebrew cask (nixpkgs build is Linux-only); config via `programs.ghostty`.
- **Sketchybar**: `.config/sketchybar` is a mutable symlink back to this repo (like nvim). Installed as a brew from the `FelixKratz/formulae` tap (auto-trusted via `~/.homebrew/trust.json`, seeded in `darwin.nix`) and started by AeroSpace on login (`brew services start sketchybar`). If the bar doesn't appear, run that manually or `sketchybar --reload`.
- **Node**: `fnm` with `--use-on-cd`, honors `.nvmrc`.
