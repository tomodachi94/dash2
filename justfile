#!/usr/bin/env just --justfile

# just is "just a command runner."
# Docs: https://just.systems/man/en/chapter_1.html

build-app:
	nix build .#dash

build-container:
	nix build .#dash-container

format:
	black $(git ls-files '*.py')
	nixpkgs-fmt $(git ls-files '*.nix')

wipe-slash-commands:
	python3 ./.github/scripts/wipe_slash_commands.py

