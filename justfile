#!/usr/bin/env just --justfile

# just is "just a command runner."
# Docs: https://just.systems/man/en/chapter_1.html

build-app:
	nix build .#dash

build-container:
	nix build .#dash-container

format:
	#!/usr/bin/env nix
	#! nix shell
	black
	nixpkgs-fmt $(git ls-files '*.nix')
