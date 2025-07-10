#!/usr/bin/env fish

### Default XDG variables

set --query XDG_CONFIG_HOME || set --global --export XDG_CONFIG_HOME "$HOME"/.config
set --query XDG_CACHE_HOME || set --global --export XDG_CACHE_HOME "$HOME"/.cache
set --query XDG_DATA_HOME || set --global --export XDG_DATA_HOME "$HOME"/.local/share
set --query XDG_STATE_HOME || set --global --export XDG_STATE_HOME "$HOME"/.local/state
set --query XDG_RUNTIME_DIR || set --global --export XDG_RUNTIME_DIR /run/user/"$UID"
set --query XDG_BIN_DIR || set --global --export XDG_BIN_DIR "$HOME"/.local/bin

fish_add_path --global --move --prepend "$XDG_BIN_DIR"

### Normalize System Variables

set --query TERM || set --global --export TERM xterm-color
set --query TERMINAL || set --global --export TERMINAL xterm
set --query UID || set --global --export UID (id -u)
set --query USER || set --global --export USER (id -un)
set --query GID || set --global --export GID (id -g)
set --query GROUP || set --global --export GROUP (id -gn)
set --query HOME || set --global --export HOME (getent passwd "$USER" | cut -d: -f6)
set --query HOSTNAME || set --global --export HOSTNAME (uname -n)
set --query OSTYPE || set --global --export OSTYPE (string lower -- (uname))
set --query MACHINE || set --global --export MACHINE (uname -m)
set --query TZ || set --global --export TZ 'America/New_York'
set --query LANG || set --global --export LANG 'en_US.UTF-8'
set --query LANGUAGE || set --global --export LANGUAGE 'en'
set --query LC_ALL || set --global --export LC_ALL 'en_US.UTF-8'

### 00-env.fish ends here
