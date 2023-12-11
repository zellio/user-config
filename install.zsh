#!/usr/bin/env zsh

set -eu -o pipefail -x

declare source_dir="${0:P:h}"

### Install config directories

for dir in "${source_dir}"/config/*(/); do
    local target="${HOME}/.${dir:t2}"

    [ -L "$target" ] && rm "$target"

    if [ -d "$target" ]; then
        echo "Directory found, skipping $target"
        continue
    fi

    ln -s "$dir" "$target"
done
