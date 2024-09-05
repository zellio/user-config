#!/usr/bin/env bash

### install.bash ---

## Copyright (C) 2024 Zachary Elliott

### Commentary:

##

### Code:

set -o nounset -o errexit -o errtrace -o pipefail

### Logging

declare -gx XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME"/.config}"

declare PROJECT_ROOT
PROJECT_ROOT="${PROJECT_ROOT:-"$(
	command cd -- "$(command dirname -- "${BASH_SOURCE[0]}")" && command pwd -P
)"}"

function main
{
	printf $'\e[38;2;255;255;255m>>>\e[0m Building config map\n'

	local -A configs=(
		["$HOME"/repos/zellio/zdotdir]="$HOME"/.config/zsh
		["$HOME"/repos/zellio/emacs-config]="$HOME"/.config/emacs
	)

	printf '  Adding home directory configs\n'

	local -a home_directory_configs=(
		'ssh/config'
		'zshenv'
	)

	printf '  Adding xdg_config directory configs\n'

	local config
	for config in "${home_directory_configs[@]}"; do
		configs["${PROJECT_ROOT}/${config}"]="${HOME}/.${config}"
	done

	for config in "$PROJECT_ROOT"/config/*; do
		configs["$config"]="${XDG_CONFIG_HOME}/$(command basename -- "$config")"
	done

	if [ "$(uname -s)" = 'Darwin' ]; then
		printf '  Adding launch agent configs\n'

		for config in "$PROJECT_ROOT"/Library/LaunchAgents/*.plist; do
			configs[$config]="${HOME}/Library/LaunchAgents/$(command basename -- "$config")"
		done
	fi

	printf $'\e[38;2;255;255;255m>>>\e[0m Linking config files\n'

	local source_path target_path
	for source_path in "${!configs[@]}"; do
		target_path="${configs[$source_path]}"

		if [ -L "$target_path" ]; then
			command rm -- "$target_path"
		fi

		if [ -e "$target_path" ]; then
			printf '  %s already exists, skipping\n' "$target_path"
		else
			printf '  Linking %s\n' "$target_path"
			command ln --symbolic -- "$source_path" "$target_path"
		fi
	done
}

main "$@"

### install.bash ends here
