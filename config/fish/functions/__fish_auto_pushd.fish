#!/usr/bin/env fish

function __fish_auto_pushd --description "zsh like auto-pushd: change directory"
    if status is-command-substitution
        builtin cd $argv
        return $status
    end

    if test (count $argv) -ge 3 && not test "$argv[1]" = '--'
        printf "%s\n" (_ "Too many args for cd command") >&2
        return 1
    end

    if test "$argv" = '-'
        if not set --query dirstack[-1]
            printf "%s\n" (_ "No pervious directory for cd command") >&2
            return 1
        end
        set argv $dirstack[-1]
    else if string match --quiet --regex '^-[[:digit:]]+$' -- "$argv"
        set --query dirstack["$argv"] && set argv $dirstack["$argv"]
    end

    set -l oldpwd "$PWD"

    builtin cd $argv
    set --local rc $status

    set --global --export dirstack (string match --invert $PWD $dirstack)
    set --global --export dirstack (string match --invert $oldpwd $dirstack) $oldpwd

    set --query __fish_dirstack_max_size
    or set --local __fish_dirstack_max_size 25

    set --query dirstack[$__fish_dirstack_max_size]
    and set --erase dirstack[1]

    return $rc
end

### __fish_auto_pushd.fish ends here
