# Dash 2

A cleanroom rewrite of [Dash](https://github.com/tomodachi94/dash) on [Lightbulb](https://github.com/tandemdude/hikari-lightbulb) and [Hikari](https://github.com/hikari-py/hikari).

Changes are documented in [the changelog](CHANGELOG.md).

## Running

Create a file named `.env` in the root of the project.
Paste this into it:

Copy the file named `example.env` in the root of the project to `.env` and modify it.

Alternatively, you can also use your hosting platform's method for setting environment variables.

Ensure you [have a Discord bot token](https://github.com/reactiflux/discord-irc/wiki/Creating-a-discord-bot-&-getting-a-token), then paste it into the `DISCORD_TOKEN` key.

Then, [obtain a Giphy API token](https://developers.giphy.com/docs/api) and paste it into the `GIPHY_TOKEN` key.

After that, run the following to install dependencies:

```bash
pip install -r requirements.txt
```

And, finally, run this to run the bot:

```bash
python dash/main.py
```
