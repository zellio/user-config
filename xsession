#/usr/bin/env sh

[ -f "$HOME/.xprofile" ] && source "$HOME/.xprofile"

# necessary to make chrome pick up the proxy settings stored in gconf.
# export DESKTOP_SESSION=gnome

# Disable audible bell
xset -b

# NOTE: This may break your compose key
# export GTK_IM_MODULE=xim

# Background color
xsetroot -solid "#333333"

# Start urxvtd
# urxvtd -q -f -o

# Start xautolock
[ -x "$HOME"/.bin/screen-locker ] && "$HOME"/.bin/screen-locker &

# Load xinitrc
[ -f "$HOME/.xinitrc" ] && source "$HOME/.xinitrc"
