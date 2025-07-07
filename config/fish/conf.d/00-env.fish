#!/usr/bin/env fish

# set fish_trace on

set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME "$HOME"/.config
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME "$HOME"/.cache
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME "$HOME"/.local/share
set -q XDG_STATE_HOME || set -gx XDG_STATE_HOME "$HOME"/.local/state
set -q XDG_RUNTIME_DIR || set -gx XDG_RUNTIME_DIR /run/user/"$UID"
set -q XDG_BIN_DIR || set -gx XDG_BIN_DIR "$HOME"/.local/bin

set -q TERM || set -gx TERM xterm-color
set -q TERMINAL || set -gx TERMINAL xterm
set -q UID || set -gx UID (id -u)
set -q USER || set -gx USER (id -un)
set -q GID || set -gx GID (id -g)
set -q GROUP || set -gx GROUP (id -gn)
set -q HOME || set -gx HOME (getent passwd "$USER" | cut -d: -f6)
set -q HOSTNAME || set -gx HOSTNAME (uname -n)
set -q OSTYPE || set -gx OSTYPE (string lower -- (uname))
set -q MACHINE || set -gx MACHINE (uname -m)

set -gx TZ 'America/New_York'
set -gx LANG 'en_US.UTF-8'
set -gx LANGUAGE 'en'
set -gx LC_ALL 'en_US.UTF-8'

### 00_env.fish ends here
