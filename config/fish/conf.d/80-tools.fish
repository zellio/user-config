#!/usr/bin/env fish

if status is-interactive && type -q atuin
    atuin init fish | source
end

if type -q aws
    set --global --export AWS_CLI_FILE_ENCODING 'UTF-8'
    set --global --export AWS_DEFAULT_OUTPUT 'json'
    set --global --export AWS_PAGER 'cat'
    set --global --export AWS_CONFIG_FILE "$XDG_CONFIG_HOME/aws/config"
    set --global --export AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME/aws/credentials"
end

if type -q docker
    set --global --export DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"
    set --global --export DOCKER_BUILDKIT '1'
    set --global --export BUILDKIT_PROGRESS 'plain'
    set --global --export COMPOSE_HTTP_TIMEOUT '120'
end

if type -q go
    set --query GOPROXY || set --global --export GOPROXY 'https://proxy.golang.org,direct'
end

if type -q gpg
    set --query GPG_TTY || set --global --export GPG_TTY (tty)
    set --global --export GNUPGHOME "$XDG_DATA_HOME/gnupg"
end

if type -q grep
    set --global --export GREP_COLORS 'ms=01;32:mc=01;31:sl=:cx=:fn=35:ln=32:bn=32:se=36'
end

if type -q less
    set --global --export LESS '-g -i -M -R -S -w -z-4'
    set --global --export LESSHISTFILE "$XDG_CACHE_HOME/less/history"
    set --global --export PAGER less
end

if type -q most
    set --global --export PAGER most
end

if type -q nvim
    alias vim 'nvim'
    alias vi 'nvim'
end

if type -q poetry
    set --global --export export POETRY_CACHE_DIR "$XDG_CACHE_HOME/poetry"
    set --global --export export POETRY_VIRTUALENVS_PATH "$XDG_DATA_HOME/virtualenvs"
end

if type -q psql
    set --global --export PSQL_HISTORY "$XDG_DATA_HOME/psql_history"
end

if type -q python
    set --global --export PYTHONPATH '.'
    set --global --export PYTHONUTF8 '1'
    set --global --export PYTHONPYCACHEPREFIX "$XDG_CACHE_HOME/python"
    set --global --export PYTHONSTARTUP "$XDG_CONFIG_HOME/python/pythonrc"

    set --global --export IPYTHONDIR "$XDG_CONFIG_HOME/ipython"

    set --global --export PYLINTHOME "$XDG_CACHE_HOME/pylint"
end

if type -q ruby
    set --global --export GEMRC "$XDG_CONFIG_HOME/gem/gemrc"

    set --global --export GEM_HOME "$XDG_DATA_HOME/gem"
    set --global --export GEM_SPEC_CACHE "$XDG_CACHE_HOME/gem"

    set --global --export BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME/bundle"
    set --global --export BUNDLE_USER_CACHE "$XDG_CACHE_HOME/bundle"
    set --global --export BUNDLE_USER_PLUGIN "$XDG_DATA_HOME/bundle"

    set --global --export SOLARGRAPH_CACHE "$XDG_CACHE_HOME/solargraph"
end

if test -n "$SSH_AUTH_SOCK"
    set --global --export SSH_AUTH_SOCK
end

if status is-interactive && type -q starship
    starship init fish | source
end

if type -q terraform
    set --global --export TF_CLI_CONFIG_FILE "$XDG_CONFIG_HOME/terraform/config.tfrc"
    set --global --export TF_PLUGIN_CACHE_DIR "$XDG_CACHE_HOME/terraform/plugin"

    if test ! -d "$TF_PLUGIN_CACHE_DIR"
        mkdir -p "$TF_PLUGIN_CACHE_DIR"
    end
end

if type -q tmux
    set --global --export TMUX_PLUGIN_MANAGER_PATH "$XDG_DATA_HOME/tmux/plugins"
end

### 80-vendor.fish ends here
