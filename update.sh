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

function generate_by_tag() {
	local tag="$1"
	local template="./Dockerfile-$tag.template"
	local target="./$tag/Dockerfile"
	generate "$template" "$target"
}

for tag in all alpine debian scratch; do
	generate_by_tag "$tag"
done
