#!/usr/bin/env fish

test -d /opt/homebrew || return

set -gx HOMEBREW_API_AUTO_UPDATE_SECS 300
set -gx HOMEBREW_AUTO_UPDATE_SECS 43200
set -gx HOMEBREW_CACHE "$XDG_CACHE_HOME"/homebrew/cache
set -gx HOMEBREW_CLEANUP_MAX_AGE_DAYS 30
set -gx HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 7
set -gx HOMEBREW_LOGS "$XDG_CACHE_HOME"/homebrew/logs
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_NO_ENV_HINTS 1

set -l HOMEBREW_DIR
switch "$MACHINE-$OSTYPE"
    case 'arm*-darwin*'
        set HOMEBREW_DIR /opt/homebrew
    case '*'
        set HOMEBREW_DIR /usr/local
end

set -l gnu_bin_pkgs 'coreutils' 'ed' 'findutils' 'gawk' 'gnu-indent' 'gnu-sed' 'gnu-tar' 'gnu-time' 'gnu-which' 'grep' 'libtool' 'make'

for pkg in $gnu_bin_pkgs
    fish_add_path --global --prepend "$HOMEBREW_DIR/opt/$pkg/libexec/gnubin"
end

set -l keg_pkgs 'berkeley-db@5' 'binutils' 'curl' 'ed' 'gnu-getopt' 'icu4c@75' 'icu4c@76' 'jpeg' 'libarchive' 'libgit2@1.7' 'libomp' 'm4' 'ncurses' 'readline' 'sqlite' 'unzip' 'zlib'

for pkg in $keg_pkgs
    fish_add_path --global --prepend "$HOMEBREW_DIR/opt/$keg/bin"
end

fish_add_path --global --append "$HOMEBREW_DIR/bin"
fish_add_path --global --append "$HOMEBREW_DIR/sbin"

### 10-homebrew.fish ends here
