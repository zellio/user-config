#!/usr/bin/env fish

function ls --wraps ls
    LC_COLLATE=C command ls --color=auto --classify=always $argv
end

### ls.fish ends here
