#!/usr/bin/env zsh

set -eu -o pipefail

declare PROJECT_ROOT="${0:P:h}"

printf '>>> Linking HOME configs\n'

declare home_configs=(
	'zshenv'
)

declare home_source home_target
for file ( $home_configs ); do
	home_source="${PROJECT_ROOT}/${file}"
	home_target="${HOME}/.${file}"

	if [ -L "$home_target" ]; then
		rm -- "$home_target"
	fi

	if [ -e "$home_target" ]; then
		printf '  Skipping %s, already exists\n' "$file"
		continue
	else
		printf '  Linking %s\n' "$file"
	fi

	ln -s "$home_source" "$home_target"
done


export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME"/.config}"

printf '>>> Linking XDG_CONFIG_HOME configs\n'

if [ ! -d "$XDG_CONFIG_HOME" ]; then
	printf '  Creating XDG_CONFIG_HOME\n'
	mkdir -p "$XDG_CONFIG_HOME"
fi

declare config_source config_target
for config_source ( "$PROJECT_ROOT"/config/* ); do
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

if [ "$(uname -s)" = 'Darwin' ]; then
	if [ ! -d "$HOME"/Library/LaunchAgents ]; then
		mkdir -p "$HOME"/Library/LaunchAgents
	fi

	printf '>>> Linking launchd agents plists\n'

	declare launch_agent_source launch_agent_target
	for launch_agent_source ( "$PROJECT_ROOT"/Library/LaunchAgents/*.plist ); do
		launch_agent_target="${HOME}/Library/LaunchAgents/${launch_agent_source:t}"

		if [ -L "$launch_agent_target" ]; then
			rm -- "$launch_agent_target"
		fi

		if [ -e "$launch_agent_target" ]; then
			printf '  Skipping %s, already exists\n' "${launch_agent_target:t}"
			continue
		fi

		printf '  Linking %s\n' "${launch_agent_target:t}"

		ln -s "$launch_agent_source" "$launch_agent_target"
	done
fi

### install.zsh ends here
