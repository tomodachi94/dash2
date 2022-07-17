#!/usr/bin/env just --justfile

# just is "just a command runner."
# Docs: https://just.systems/man/en/chapter_1.html

start:
	python3 ./dash/main.py

install:
    python3 -m pip install -r ./requirements.txt
    cp ./example.env ./.env
    echo "Edit .env to configure the bot."

install-fancy: install
	echo "Launching " $EDITOR " to configure Dash."
	cp ./example.env .env
	$EDITOR .env

install-dev: install
	pip install -r ./requirements-dev.txt

check: install-dev
	python3 -m flake8 dash