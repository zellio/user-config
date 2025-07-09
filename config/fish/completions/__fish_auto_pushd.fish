#!/usr/bin/env fish

function __fish_complete_condition_auto_pushd
    string match --quiet '*-' -- (commandline) && test (count $dirstack) -gt 0
end

function __fish_complete_auto_pushd
    set -l dirstack (dirs)
    for idx in (seq 1 (count $dirstack))
        printf '-%s\t%s\n' $idx "Changes to $dirstack[$idx]"
    end
end

complete --command __fish_auto_pushd --no-files --condition '__fish_complete_condition_auto_pushd' --arguments "(__fish_complete_auto_pushd)"
complete --command __fish_auto_pushd --force-files --condition 'not __fish_complete_condition_auto_pushd'

### __fish_auto_pushd.fish ends here
