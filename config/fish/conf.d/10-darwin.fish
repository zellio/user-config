#!/usr/bin/env fish

string match --ignore-case --quiet -- 'darwin*' "$OSTYPE" || return

### Initialize PATH from path_helper

set PATH (string match --groups-only --regex -- '"(.*)"' (env - /usr/libexec/path_helper))

### Fake XDG runtime directory location

set --global --export XDG_RUNTIME_DIR "$XDG_CACHE_HOME"/run
if test ! -d "$XDG_RUNTIME_DIR"
    command mkdir --mode=0700 "$XDG_RUNTIME_DIR"
end

### Correct XDG paths to OSX defaults

set --global --export XDG_DESKTOP_DIR "$HOME"/Desktop
set --global --export XDG_DOCUMENTS_DIR "$HOME"/Documents
set --global --export XDG_DOWNLOAD_DIR "$HOME"/Downloads
set --global --export XDG_MUSIC_DIR "$HOME"/Music
set --global --export XDG_PICTURES_DIR "$HOME"/Pictures
set --global --export XDG_VIDEOS_DIR "$HOME"/Videos
set --global --export XDG_PROJECTS_DIR "$HOME"/Projects

### 30-darwin.fish ends here
