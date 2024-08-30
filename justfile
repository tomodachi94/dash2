#!/usr/bin/env just --justfile

# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT

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

reuse:
	reuse lint

ruff:
	ruff check $(git ls-files '*.py')

check: ruff reuse

check-formatting:
	treefmt --fail-on-change

wipe-slash-commands:
	python3 ./.github/scripts/wipe_slash_commands.py

ci: check check-formatting
