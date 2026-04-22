# Ava's Dotfiles

macOS setup managed declaratively with [Nix flakes][flakes], [nix-darwin][nix-darwin], and [home-manager][hm]. One command brings a fresh Mac up to a fully configured machine: GUI apps, CLI tools, shell, editor, window manager, keyboard remapper, terminal — the lot.

[flakes]: https://nixos.wiki/wiki/Flakes
[nix-darwin]: https://github.com/LnL7/nix-darwin
[hm]: https://github.com/nix-community/home-manager

## What's here

| File | Purpose |
|---|---|
| `flake.nix` | Flake inputs + outputs (`darwinConfigurations.ava`, `homeConfigurations.ava`) |
| `darwin.nix` | System-level config: Homebrew casks, fonts, macOS `system.defaults` |
| `home.nix` | User-level config: shell, CLI tools, program configs, raw file links |
| `.config/*`  | Config files that are either linked raw (nvim, karabiner, htop) or read as sources by `home.nix` (bat themes) |
| `.p10k.zsh`  | Powerlevel10k prompt configuration, linked into `$HOME` |

Everything in this repo is reproducible from `home.nix` + `darwin.nix`. The tools that write back into their config dirs (LazyVim's `lazy-lock.json`, Karabiner's `automatic_backups/`, `htoprc`) are linked with `mkOutOfStoreSymlink` so they stay editable in place — edits land in the repo, not in `/nix/store`.

## First-time setup on a new Mac

### 1. Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

The Determinate installer enables flakes by default. If you're using the official installer instead, create `~/.config/nix/nix.conf` with `experimental-features = nix-command flakes`.

### 2. Install Homebrew

nix-darwin uses Homebrew for macOS `.app` bundles that either aren't packaged for darwin in nixpkgs or work better as native apps.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 3. Clone this repo

```sh
git clone https://github.com/<you>/dotfiles ~/dotfiles
cd ~/dotfiles
```

### 4. Back up any existing config that would collide

home-manager refuses to overwrite existing files at activation. Before the first switch, move anything that lives at the same path as a managed file out of the way:

```sh
for f in ~/.zshrc ~/.p10k.zsh ~/.config/ghostty/config ~/.config/tmux/tmux.conf \
         ~/.config/bat/config ~/.config/yazi/yazi.toml ~/.config/aerospace/aerospace.toml \
         ~/.config/git/config ~/.config/git/ignore ~/.config/gh/config.yml; do
  [ -e "$f" ] && [ ! -L "$f" ] && mv "$f" "$f.pre-nix"
done
```

Tools that write to their own config dir (`~/.config/nvim`, `~/.config/htop`) are linked as mutable symlinks back to this repo. If existing dirs are in the way:

```sh
for d in ~/.config/nvim ~/.config/htop; do
  [ -e "$d" ] && [ ! -L "$d" ] && mv "$d" "$d.pre-nix"
done
```

### 5. Run the first switch

```sh
nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/dotfiles#ava
```

Run this as yourself — **do not prefix with `sudo`**. `darwin-rebuild` escalates internally where it needs root (writing to `/etc`, running cask installers). Running the outer command under `sudo` makes `nix` fall back to root's `$HOME` and creates ownership weirdness.

This installs `darwin-rebuild`, all CLI tools, GUI apps via Homebrew, and activates home-manager. The first run downloads a lot — subsequent runs are fast.

### 6. One-time manual steps

Nix can't automate these:

- **Karabiner-Elements**: grant Input Monitoring + Accessibility permissions in System Settings → Privacy & Security
- **AeroSpace**: grant Accessibility permission
- **Homerow**: grant Accessibility permission, launch once to activate
- **DisplayLink Manager**: grant Screen Recording permission
- **GitHub CLI**: `gh auth login` (tokens live in `~/.config/gh/hosts.yml`, not managed by Nix)
- **Bun**: `curl -fsSL https://bun.sh/install | bash` if you want the bun toolchain beyond the `pkgs.bun` binary

## Ongoing use

### Apply changes after editing `home.nix` / `darwin.nix`

```sh
darwin-rebuild switch --flake ~/dotfiles#ava
```

### Home-manager only (faster, skips system-level rebuild)

```sh
home-manager switch --flake ~/dotfiles#ava
```

### Update all inputs (nixpkgs, home-manager, nix-darwin)

```sh
nix flake update
darwin-rebuild switch --flake ~/dotfiles#ava
```

### Roll back a bad generation

```sh
darwin-rebuild --list-generations
darwin-rebuild switch --flake ~/dotfiles#ava --rollback
```

## Adding things

- **A CLI tool** → add to `home.packages` in `home.nix`
- **A GUI app packaged for darwin in nixpkgs** → add to `home.packages`
- **A GUI app that only ships as a `.app` / Mac App Store build** → add to `homebrew.casks` in `darwin.nix`
- **A macOS system setting** → add to `system.defaults` in `darwin.nix`. Inspect available options with `darwin-rebuild.doc defaults` or see the [nix-darwin manual][darwin-manual]
- **A new shell alias** → `programs.zsh.shellAliases` in `home.nix`
- **A raw config file linked in place** → add an `xdg.configFile` or `home.file` entry. Use `mkLink "${dotfilesDir}/path"` for writable links, `./path` for immutable

[darwin-manual]: https://daiderd.com/nix-darwin/manual/index.html

## Notes on specific tools

- **LazyVim**: `.config/nvim` is a mutable symlink back into this repo. `lazy-lock.json` is committed here — edit plugins, let LazyVim update the lock, commit it
- **Karabiner-Elements**: config lives at `~/.config/karabiner/karabiner.json` (Karabiner rewrites it atomically, which breaks symlinks — so we don't link it). The repo copy at `.config/karabiner/` is a manually synced backup. After meaningful changes: `cp ~/.config/karabiner/karabiner.json ~/dotfiles/.config/karabiner/` then commit. On a fresh machine, reverse: `cp ~/dotfiles/.config/karabiner/karabiner.json ~/.config/karabiner/` (quit Karabiner first)
- **Ghostty**: installed via Homebrew cask (nixpkgs' ghostty is Linux-only), config is generated by home-manager
- **AeroSpace**: installed via nixpkgs, launchd agent managed by home-manager so it starts at login
- **tmux**: TPM is no longer used — all plugins come from `pkgs.tmuxPlugins.*`
- **zsh plugins**: Zinit is no longer used — `pkgs.zsh-powerlevel10k`, `pkgs.zsh-vi-mode`, `pkgs.zsh-fzf-tab`, plus syntax-highlighting/autosuggestion/completions wired via `programs.zsh`
- **Node**: `fnm` replaces `nvm`. `.nvmrc` files are auto-honored via `fnm env --use-on-cd`
