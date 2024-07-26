#!/usr/bin/env just --justfile

# just is "just a command runner."
# Docs: https://just.systems/man/en/chapter_1.html

run:
	poetry install
	poetry run dash

build-app:
	nix build .#dash

build-container:
	nix build .#dash-container

format:
	treefmt

check:
	ruff check $(git ls-files '*.py')
	poetry env use system && mypy -p dash

check-formatting:
	treefmt --fail-on-change

wipe-slash-commands:
	python3 ./.github/scripts/wipe_slash_commands.py

ci: check check-formatting
