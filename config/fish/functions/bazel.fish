#!/usr/bin/env fish

function bazel --wraps bazel
    if type -q bazelisk
        bazelisk $argv
    else
        comamnd bazel --bazelrc "$XDG_CONFIG_HOME"/bazel/bazelrc $argv
    end
end

### bazel.fish ends here
