#!/usr/bin/env fish

function wget --wraps wget
    set --local wget_data_dir "$XDG_DATA_HOME/wget"
    if test ! -d "$wget_data_dir"
        mkdir --parents "$wget_data_dir"
    end

    set --local wget_opts "--hsts-file" "$WGET_DATA_DIR/hsts"

    command wget $wget_opts $argv
end
