#!/usr/bin/env fish

function history --description 'atuin history adapter'
    set --query argv || set --local argv 'list'
    command atuin history $argv
end
