#!/usr/bin/env fish

function popd --description "zsh like auto-pushd: pop directory"
    if not set --query dirstack[-1]
        printf '%s\n' (_ "Nothing to pop, dirstack is empty")
        return 1
    end

    set --local previous_path $dirstack[-1]
    set --erase dirstack[-1]

    builtin cd "$previous_path"
end

### popd.fish ends here
