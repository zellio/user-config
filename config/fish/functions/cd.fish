#!/usr/bin/env fish

function cd --description 'zsh like auto-pushd: change directory' --wraps __fish_auto_pushd
    __fish_auto_pushd $argv
end

### cd.fish ends here
