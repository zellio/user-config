#!/usr/bin/env bash

### install.bash ---

## Copyright (C) 2025 Zachary Elliott

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

function report_info
{
	local msg="$*"
	printf $'\e[38;2;0;255;0m==>\e[0m %s\n' "$msg"
}

function report_warning
{
	local msg="$*"
	printf $'\e[38;2;255;255;0m==> WARNING:\e[0m %s\n' "$msg"
}

function report_action
{
	local msg="$*"
	printf $'  \e[38;2;0;0;255m->\e[0m %s\n' "$msg"
}

function main
{
	report_info 'Building config map'

	local -A configs=(
		["$HOME"/repos/zellio/zdotdir]="$HOME"/.config/zsh
		["$HOME"/repos/zellio/emacs-config]="$HOME"/.config/emacs
	)

	report_action 'Adding home directory configs'

	local -a home_directory_configs=(
		'ssh/config'
		'zshenv'
	)

	report_action 'Adding xdg_config directory configs'

	local config
	for config in "${home_directory_configs[@]}"; do
		configs["${PROJECT_ROOT}/${config}"]="${HOME}/.${config}"
	done

	for config in "$PROJECT_ROOT"/config/*; do
		configs["$config"]="${XDG_CONFIG_HOME}/$(command basename -- "$config")"
	done

	if [ "$(uname -s)" = 'Darwin' ]; then
		report_action 'Adding launch agent configs'

		for config in "$PROJECT_ROOT"/Library/LaunchAgents/*.plist; do
			configs[$config]="${HOME}/Library/LaunchAgents/$(command basename -- "$config")"
		done
	fi

	report_info 'Linking config files'

	local source_path target_path
	for source_path in "${!configs[@]}"; do
		target_path="${configs[$source_path]}"

		if [ -L "$target_path" ]; then
			report_action "Relinking ${target_path}"
			command rm -- "$target_path"
			command ln --symbolic -- "$source_path" "$target_path"
		elif [ -e "$target_path" ]; then
			report_warning "${target_path} already exists, skipping"
		else
			report_action "Linking ${target_path}"
			command ln --symbolic -- "$source_path" "$target_path"
		fi
	done
}

main "$@"

### install.bash ends here
