#!/usr/bin/env bash

set -eu -o pipefail

function main
{
	local current_space_type
	current_space_type="$(
		/opt/homebrew/bin/yabai --message query --spaces --space |
			jq --raw-output '.type'
	)"

	local target_space_type
	case "$current_space_type" in
		bsp)
			target_space_type='stack'
			;;

		stack)
			target_space_type='bsp'
			;;

		*)
			return 1
			;;
	esac

	yabai --message space --layout "$target_space_type"
}

main "$@"
