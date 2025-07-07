#!/usr/bin/env fish

if status is-interactive && type -q atuin
    atuin init fish | source
end

if type -q aws
    set -gx AWS_CLI_FILE_ENCODING 'UTF-8'
    set -gx AWS_DEFAULT_OUTPUT 'json'
    set -gx AWS_PAGER 'cat'
    set -gx AWS_CONFIG_FILE "$XDG_CONFIG_HOME"/aws/config
    set -gx AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME"/aws/credentials
end

if type -q docker
    set -gx export DOCKER_CONFIG "$XDG_CONFIG_HOME"/docker
    set -gx DOCKER_BUILDKIT '1'
    set -gx BUILDKIT_PROGRESS 'plain'
    set -gx COMPOSE_HTTP_TIMEOUT '120'
end

if type -q gpg
    set -q GPG_TTY || set -gx GPG_TTY (tty)
    set -gx GNUPGHOME "$XDG_DATA_HOME"/gnupg
end

if type -q grep
    set -gx GREP_COLORS 'ms=01;32:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
end

if type -q less
    set -gx LESS '-g -i -M -R -S -w -z-4'
    set -gx LESSHISTFILE "$XDG_CACHE_HOME"/less/history
    set -gx PAGER less
end

if type -q most
    set -gx PAGER most
end

if type -q nvim
    alias vim 'nvim'
    alias vi 'nvim'
end

if type -q poetry
    set -gx export POETRY_CACHE_DIR "$XDG_CACHE_HOME"/poetry
    set -gx export POETRY_VIRTUALENVS_PATH "$XDG_DATA_HOME"/virtualenvs
end

if type -q psql
    set -gx PSQL_HISTORY "$XDG_DATA_HOME"/psql_history
end

if type -q python
    set -gx PYTHONPATH '.'
    set -gx PYTHONUTF8 '1'
    set -gx PYTHONPYCACHEPREFIX "$XDG_CACHE_HOME"/python
    set -gx PYTHONSTARTUP "$XDG_CONFIG_HOME"/python/pythonrc

    set -gx IPYTHONDIR "$XDG_CONFIG_HOME"/ipython

    set -gx PYLINTHOME "$XDG_CACHE_HOME"/pylint
end

if type -q ruby
    set -gx GEMRC "$XDG_CONFIG_HOME"/gem/gemrc

    set -gx GEM_HOME "$XDG_DATA_HOME"/gem
    set -gx GEM_SPEC_CACHE "$XDG_CACHE_HOME"/gem

    set -gx BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME"/bundle
    set -gx BUNDLE_USER_CACHE "$XDG_CACHE_HOME"/bundle
    set -gx BUNDLE_USER_PLUGIN "$XDG_DATA_HOME"/bundle

    set -gx SOLARGRAPH_CACHE "$XDG_CACHE_HOME"/solargraph
end

if test -n "$SSH_AUTH_SOCK"
    set -gx SSH_AUTH_SOCK
end

if status is-interactive && type -q starship
    starship init fish | source
end

if type -q terraform
    set -gx TF_CLI_CONFIG_FILE "$XDG_CONFIG_HOME"/terraform/config.tfrc
    set -gx TF_PLUGIN_CACHE_DIR "$XDG_CACHE_HOME"/terraform/plugin

    if test ! -d "$TF_PLUGIN_CACHE_DIR"
        mkdir -p "$TF_PLUGIN_CACHE_DIR"
    end
end

if type -q tmux
    set -gx TMUX_PLUGIN_MANAGER_PATH "$XDG_DATA_HOME"/tmux/plugins/tpm
end

### 80-vendor.fish ends here
