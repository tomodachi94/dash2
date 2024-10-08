<!--
SPDX-FileCopyrightText: 2024 Tomodachi94

SPDX-License-Identifier: CC-BY-NC-SA-4.0
-->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.4.1

- Add Docker support.
- Move `dash/main.py` to `dash/__main__.py`, for potential compatibility with Zipapp or other methods of bundling.

## v0.4.0

- Implement `article` command group (#12, Tomodachi94)
    - Implement `article links` command, which shows links to other pages.
    - Implement `article revision` command, which shows a page's revision ID and a permanent link to it.
	- Implement `article random` command, which shows a random page.

## v0.3.2
- Fix extension path bug. (c463746321ff197991e6a180eb6bdabda7c8b1c3, Tomodachi94)

## v0.3.1

- Migrate commands to Lightbulb's extensions. (#10, Tomodachi94)
- Move `dash/bot.py` to `dash/main.py`.


## v0.3.0

- Added `bunny` command. Requires a Giphy API token. (#8, Tomodachi94)
- Added support for slash commands. (#6, Tomodachi94)

## v0.2.0

- Added `about` command. (58d8bb79a8693d9ce84a1dc81f680b9e9542b872, Tomodachi94)
- Added `Procfile` to enable deployment to [Heroku](https://heroku.com). (#1, Tomodachi94)
- Various improvements to documentation. (#5, Tomodachi94)

## v0.1.0
- Initial commit (a475ec494f2e2b4fd173a2c67b713a8644bff5cc, Tomodachi94)
