#!/usr/bin/env zsh

### Initialize XDG Base Directory Specification

typeset -gx XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME"/.local/share}"
typeset -gx XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME"/.config}"
typeset -gx XDG_STATE_HOME="${XDG_STATE_HOME:-"$HOME"/.local/state}"
typeset -gx XDG_BIN_HOME="${XDG_BIN_HOM:-"$HOME"/.local/bin}"
typeset -gx XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME"/.cache}"

typeset -gx XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
typeset -gx XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"

typeset -gx XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/"$UID"}"

### ZSH Shell Parameters

typeset -gx DIRSTACKSIZE=25
typeset -gx HISTFILE="$XDG_DATA_HOME"/zsh/history
typeset -gx HISTORY_IGNORE=' *|fc *'
typeset -gx HISTSIZE=100000
typeset -gx NULLCMD='cat'
typeset -gx PS1="${PS1:-'%n@%m:%~ %# '}"
typeset -gx PS2="${PS2:-}"
typeset -gx PS3="${PS3:-}"
typeset -gx PS4="${PS4:-}"
typeset -gx READNULLCMD='more'
typeset -gx RPS1="${PS1:-}"
typeset -gx RPS2="${PS2:-}"
typeset -gx SAVEHIST="$HISTSIZE"
typeset -gx TIMEFMT="%J
Time: %U user | %S system | %P cpu | %*E total | %M KiB max RSS"
typeset -gx ZDOTDIR="${ZDOTDIR:-"$XDG_CONFIG_HOME"/zsh}"
typeset -gx REPORTTIME=10
typeset -gx WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

### .zshenv ends here
