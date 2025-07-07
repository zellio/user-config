#!/usr/bin/env fish

function grep --wraps grep
    command grep --color=auto $argv
end

### grep.fish ends here
