# Dash 2

A cleanroom rewrite of [Dash](https://github.com/tomodachi94/dash) on [Lightbulb](https://github.com/tandemdude/hikari-lightbulb) and [Hikari](https://github.com/hikari-py/hikari).

Changes are documented in [the changelog](CHANGELOG.md).

## Installing

Running is easy if you have [just](https://just.systems/man/en/chapter_1.html) and [Nix](https://nixos.org] installed.

[direnv](https://direnv.net/), and [direnv-nix](https://github.com/nix-community/nix-direnv) are also helpful, but not required.

### OCI/Docker container with Nix

```sh
docker load < $(nix build .#dash-container)
# Jump to "Configuration", then run the container the normal way
```

### Executable with Nix

```sh
nix build .#dash
# Jump to "Configuration", then...
./result/bin/dash
```

### Manually without Nix

Install [Poetry](https://python-poetry.org/docs/#installation).

Copy the file named `example.env` in the root of the project to `.env` and modify it.

Alternatively, you can also use your hosting platform's method for setting environment variables.

Ensure you [have a Discord bot token](https://github.com/reactiflux/discord-irc/wiki/Creating-a-discord-bot-&-getting-a-token), then paste it into the `DISCORD_TOKEN` key.

Then, [obtain a Giphy API token](https://developers.giphy.com/docs/api) and paste it into the `GIPHY_TOKEN` key.

And, finally, run this to run the bot:

```bash
poetry install
python3 -m dash
```

## Configuration

The bot is configured entirely through environment variables. Sample values are provided in `extras/example.env`.

### Command prefix

`DISCORD_PREFIX` controls what the prefix of the commands is. It defaults to `_`.

**Example value**: `?`

### MediaWiki instance

`MEDIAWIKI_API` and `MEDIAWIKI_BASE_URL` control the API URL and the MediaWiki base URL for the MediaWiki extension.

`MEDIAWIKI_API` example value: `https://ftb.fandom.com/api.php`

`MEDIAWIKI_BASE_URL` example value: `https://ftb.fandom.com/wiki/`

### Tokens

Ensure you [have a Discord bot token](https://github.com/reactiflux/discord-irc/wiki/Creating-a-discord-bot-&-getting-a-token), then set it in the `DISCORD_TOKEN` variable.

Then, [obtain a Giphy API token](https://developers.giphy.com/docs/api) and set it in the `GIPHY_TOKEN` variable.

## Development

Install Nix, then use `nix develop`. If you have `direnv` and `nix-direnv` installed, you can use `direnv allow` and have the shell environment activated automatically.
