#!/usr/bin/env fish

function bazelisk --wraps bazelisk
    command bazelisk --bazelrc "$XDG_CONFIG_HOME"/bazel/bazelrc $argv
end

### bazelisk.fish ends here
