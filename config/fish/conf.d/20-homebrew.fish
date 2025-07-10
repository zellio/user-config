#!/usr/bin/env fish

set --local HOMEBREW_DIR
switch "$MACHINE-$OSTYPE"
    case 'arm*-darwin*'
        set HOMEBREW_DIR /opt/homebrew
    case '*'
        set HOMEBREW_DIR /usr/local
end

test -e "$HOMEBREW_DIR/bin/brew" || return

set --global --export HOMEBREW_DIR "$HOMEBREW_DIR"
set --global --export HOMEBREW_API_AUTO_UPDATE_SECS 300
set --global --export HOMEBREW_AUTO_UPDATE_SECS 43200
set --global --export HOMEBREW_CACHE "$XDG_CACHE_HOME"/homebrew/cache
set --global --export HOMEBREW_CLEANUP_MAX_AGE_DAYS 30
set --global --export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS 7
set --global --export HOMEBREW_LOGS "$XDG_CACHE_HOME"/homebrew/logs
set --global --export HOMEBREW_NO_ANALYTICS 1
set --global --export HOMEBREW_NO_ENV_HINTS 1

set --local gnubin_packages 'coreutils' 'ed' 'findutils' 'gawk' 'gnu-indent' 'gnu-sed' 'gnu-tar' 'gnu-time' 'gnu-which' 'gpatch' 'grep' 'libtool' 'make'
for gnubin_package in $gnubin_packages
    fish_add_path --path --prepend "$HOMEBREW_DIR/opt/$gnubin_package/libexec/gnubin"
end

set --local keg_only_packages 'berkeley-db@5' 'binutils' 'bison' 'curl' 'ed' 'expat' 'gnu-getopt' 'icu4c@77' 'jpeg' 'libarchive' 'libiconv' 'libomp' 'm4' 'ncurses' 'openblas' 'openjdk' 'readline' 'sqlite' 'unzip' 'zlib'
for keg_only_package in $keg_only_packages
    fish_add_path --path --prepend "$HOMEBREW_DIR/opt/$keg_only_package/bin"
end

fish_add_path --path --prepend "$HOMEBREW_DIR/bin"
fish_add_path --path --prepend "$HOMEBREW_DIR/sbin"

set --global --export --prepend PKG_CONFIG_PATH "$HOMEBREW_DIR/lib/pkgconfig" "$HOMEBREW_DIR/share/pkgconfig"
set --global --export --prepend CFLAGS "-I$HOMEBREW_DIR/include"
set --global --export --prepend CPPFLAGS "-I$HOMEBREW_DIR/include"
set --global --export --prepend LDFLAGS "-L$HOMEBREW_DIR/lib"

### 10-homebrew.fish ends here
