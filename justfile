#!/usr/bin/env just --justfile

# just is "just a command runner."
# Docs: https://just.systems/man/en/chapter_1.html

PYTHON_BINARY := "./.venv/bin/python"
PIP_BINARY := "./.venv/bin/pip"

start:
	python3 ./dash/__main__.py

init-virtualenv:
	python3 -m venv ./.venv/

install: init-virtualenv
    {{ PIP_BINARY }} install -r ./requirements.txt
    cp ./example.env ./.env
    echo "Edit .env to configure the bot."

install-fancy: install
	echo "Launching " $EDITOR " to configure Dash."
	cp ./example.env .env
	$EDITOR .env

install-dev: install
	{{PIP_BINARY}} install -r ./requirements-dev.txt -qqq

check: install-dev
	python3 -m flake8 dash

