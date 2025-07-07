#!/usr/bin/env fish

function rlwrap --wraps rlwrap
    set -l history_directory "$XDG_DATA_HOME"/rlwrap/history
    test -d "$history_directory" || mkdir -p "$history_directory"

    set -l wrapped_command (path basename $argv[1])
    set -l rlwrap_args '--ansi-colour-aware' '--complete-filenames' '--histsize=10000' '--history-no-dupes=1' "--history-filename=$history_directory/$command"

    command rlwrap $rlwrap_args $argv
end

### rlwarp.fish ends here
