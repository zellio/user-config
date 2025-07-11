#!/usr/bin/env fish

function history --description 'atuin history adapter'
    test -z "$argv"; and set --function argv 'list'
    command atuin history $argv
end

### history.fish ends here
