# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::command-not-found

# Vi Mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode
EDITOR=nvim

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias vi='nvim'
alias cat='bat'
alias 綺麗に='clear'
alias 家="cd ~"
alias 物="cd ~/Developer/monorepo/"
alias ヴィ="vim"
alias ls="eza --color=always --icons"
alias vimconfig="vim ~/.config/nvim/init.lua"
alias zshconfig="vim ~/.zshrc && source ~/.zshrc"
alias la="ls -la"
alias gr="grep -Fr --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=.next --exclude-dir=.git --exclude-dir=.turbo --exclude-dir=out --exclude-dir=playwright-report --exclude-dir=design-system"

mdn() {
  open "https://developer.mozilla.org/en-US/search?q=$@"
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
export ZLE_RPROMPT_INDENT=4
export BAT_THEME=tokyonight_night

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    ls)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    cat)          fzf "$@" --preview 'bat --style=numbers --color=always --line-range :500 {}' ;;
    vim)          fzf "$@" --preview 'bat --style=numbers --color=always --line-range :500 {}' ;;
    *)            fzf "$@" ;;
  esac
}


# Herd injected PHP binary.
export PATH="/Users/clark/Library/Application Support/Herd/bin/":$PATH
export PATH="/Users/clark/dotfiles/.config/emacs/bin":$PATH


# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/clark/Library/Application Support/Herd/config/php/82/"


# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/clark/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP 8.4 configuration.
export HERD_PHP_84_INI_SCAN_DIR="/Users/clark/Library/Application Support/Herd/config/php/84/"

hyfetch --ascii /Users/clark/dotfiles/ascii.txt
