#!/usr/bin/env zsh

set -eu -o pipefail

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME"/.config}"

printf '>>> Installing XDG_CONFIG_HOME\n'

if [ ! -d "$XDG_CONFIG_HOME" ]; then
	printf '  Creating XDG_CONFIG_HOME\n'
	mkdir -p "$XDG_CONFIG_HOME"
fi

declare config_source config_target
for config_source ( "${0:P:h}/config"/* ); do
	config_target="${XDG_CONFIG_HOME}/${config_source:t}"

	if [ -L "$config_target" ]; then
		rm -- "$config_target"
	fi

	if [ -e "$config_target" ] && ; then
		printf '  Skipping %s, already exists\n' "${config_source:t2}"
		continue
	else
		printf '  Linking %s\n' "${config_source:t2}"
	fi

	ln -s "$config_source" "$config_target"
done
