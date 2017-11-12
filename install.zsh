#!/usr/bin/env zsh

set -ex

root="${0:A:h}"

find "$root" -mindepth 1 -a -name '.*' -prune -o -type d -print0 |
	xargs -L1 -0 echo |
	while IFS= read -r line; do
		mkdir -p "${line//$root\//${HOME}/.}"
	done

find "$root" -mindepth 1 -a -name '.*' -prune -o ! -name 'README.md' ! -name 'install.zsh' -type f -print0 |
	xargs -L1 -0 echo |
	while IFS= read -r line; do
		cp "$line" "${line//$root\//${HOME}/.}"
	done
