#!/usr/bin/env bash

set -eu -o pipefail

function main
{
	local split_type="$(
		/opt/homebrew/bin/yabai --message query --windows --window |
			jq --raw-output '."split-type"'
	)"

	if [ "$split_type" = 'horizontal' ]; then
		/opt/homebrew/bin/yabai --message window --toggle split
	fi
}

main "$@"
