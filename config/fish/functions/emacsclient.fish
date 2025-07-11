#!/usr/bin/env fish

function emacsclient --wraps emacsclient
    set --local emacs_socket_name 'systemd-user.service'
    if type -q launchctl
        set emacs_socket_name 'launchd-user.plist'
    else if type -q systemctl
        set emacs_socket_name 'systemd-user.service'
    end

    set --local emacsclient_opts "--socket-name=$XDG_RUNTIME_DIR/emacs/$emacs_socket_name"

    set --local displays (command emacsclient $emacsclient_opts --alternate-editor '' --eval '(x-display-list)')
    if test -z "$displays" || test "$displays" = "nil"
        set --append emacsclient_opts '--create-frame'
    end

    set --append emacsclient_opts "--alternate-editor='emacs -nw'"

    command emacsclient $emacsclient_opts $argv
end

### emacsclient.fish ends here
