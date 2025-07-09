#!/usr/bin/env fish

function dirs --description 'zsh like auto-pushd: view and manipulate directory stack'
    set -l options h/help c/clear f/full-paths
    argparse -n dirs --max-args=0 $options -- $argv || return

    if set --query _flag_help
        __fish_print_help dirs
        return 0
    end

    if set --query _flag_clear
        set --erase --global dirstack
        return 0
    end

    if set --query _flag_full_paths
        printf '%s\n' $dirstack[-1..1]
    else
        printf '%s\n' (string replace --regex '^'"$HOME"'($|/)' '~$1' $dirstack[-1..1])
    end
end

### dirs.fish
