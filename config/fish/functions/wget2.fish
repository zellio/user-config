#!/usr/bin/env fish

function wget2 --wraps wget2
    set --local wget2_data_dir "$XDG_DATA_HOME/wget2"
    if test ! -d "$wget2_data_dir"
        mkdir --parents "$wget2_data_dir"
    end

    set --local "--hsts-file" "$wget2_data_dir/hsts" "--hpkp-file" "$wget2_data_dir/hpkp" "--tls-session-file" "$wget2_data_dir/tls-session" "--ocsp-file" "$wget2_data_dir/ocsp"

    command wget2 $wget2_opts $argv
end

### wget2.fish ends here
