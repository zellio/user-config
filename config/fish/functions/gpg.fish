#!/usr/bin/env fish

function gpg --wraps gpg
    GPG_TTY=(tty) gpg $argv
end

### gpg.fish ends here
