#!/bin/bash -Eeuo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

TEMPLATE_BUILDER=$(cat ./Dockerfile-0-builder)
TEMPLATE_FACADE=$(cat ./Dockerfile-1-facade)

function generate() {
	local template="$1"
	local target="$2"
	if [ -f "$target" ]; then
		cat "$template" | TEMPLATE_BUILDER="$TEMPLATE_BUILDER" TEMPLATE_FACADE="$TEMPLATE_FACADE" envsubst >"$target"
		echo "$target updated."
	else
		echo >&2 "File not found ($target)"
		exit 2
	fi
}

generate ./Dockerfile-latest.template ./Dockerfile
generate ./Dockerfile-all.template ./all/Dockerfile
generate ./Dockerfile-alpine.template ./alpine/Dockerfile
generate ./Dockerfile-scratch.template ./scratch/Dockerfile
