#!/usr/bin/env fish

string match --ignore-case --quiet -- 'darwin*' "$OSTYPE" || return

set -gx XDG_RUNTIME_DIR "$XDG_CACHE_HOME"/run

if test ! -d "$XDG_RUNTIME_DIR"
    mkdir "$XDG_RUNTIME_DIR"
    chmod 0700 "$XDG_RUNTIME_DIR"
end

set -gx XDG_DESKTOP_DIR "$HOME"/Desktop
set -gx XDG_DOCUMENTS_DIR "$HOME"/Documents
set -gx XDG_DOWNLOAD_DIR "$HOME"/Downloads
set -gx XDG_MUSIC_DIR "$HOME"/Music
set -gx XDG_PICTURES_DIR "$HOME"/Pictures
set -gx XDG_VIDEOS_DIR "$HOME"/Videos
set -gx XDG_PROJECTS_DIR "$HOME"/Projects

### 30-darwin.fish ends here
