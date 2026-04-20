#!/usr/bin/env bash

### install.bash ---

## Copyright (C) 2025 Zachary Elliott

### Commentary:

##

### Code:

set -o nounset -o errexit -o errtrace -o pipefail

### Setting global variables

declare -gx XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME"/.cache}"
declare -gx XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME"/.config}"
declare -gx XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME"/.local/share}"
declare -gx XDG_STATE_HOME="${XDG_STATE_HOME:-"$HOME"/.local/state}"
declare -gx XDG_BIN_DIR="${XDG_BIN_DIR:-"$HOME"/.local/bin}"

declare PROJECT_ROOT
PROJECT_ROOT="${PROJECT_ROOT:-"$(
	command cd -- "$(command dirname -- "${BASH_SOURCE[0]}")" && command pwd -P
)"}"

declare -A SOURCE_MAP=(
	["$XDG_CACHE_HOME"]='cache'
	["$XDG_CONFIG_HOME"]='config'
	["$XDG_DATA_HOME"]='local/share'
	["$XDG_STATE_HOME"]='local/state'
	["$XDG_BIN_DIR"]='local/bin'
)

### Logging

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

	if [ "$(uname -s)" = 'Darwin' ]; then
		report_action 'Adding Darwin specific launch agents to search set'
		SOURCE_MAP["$HOME"/Library/LaunchAgents]='Library/LaunchAgents'
	fi

	local -A configs=(
		["$HOME"/repos/zellio/emacs-config]="$HOME"/.config/emacs
	)

	report_action 'Adding home directory configs'

	local -a home_directory_configs=(
		'ssh/config'
		'zshenv'
	)

	local config
	for config in "${home_directory_configs[@]}"; do
		configs["${PROJECT_ROOT}/${config}"]="${HOME}/.${config}"
	done

	local key value
	local -a discovered source
	for key in "${!SOURCE_MAP[@]}"; do
		value="${SOURCE_MAP[$key]}"
		[ -d "$value" ] || continue

		report_action "Processing source map: $value"

		readarray -t -d$'\n' discovered < <(
			find "${PROJECT_ROOT}/${value}" -mindepth 1 -maxdepth 1
		)
		for source in "${discovered[@]}"; do
			configs[$source]="${key}/$(basename "$source")"
		done
	done

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
