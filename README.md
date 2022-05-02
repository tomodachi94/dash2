# Dash 2

A cleanroom rewrite of [Dash](https://github.com/tomodachi94/dash) on [Lightbulb](https://github.com/tandemdude/hikari-lightbulb) and [Hikari](https://github.com/hikari-py/hikari).

Changes are documented in [the changelog](CHANGELOG.md).

## Running

Create a file named `.env` in the root of the project.
Paste this into it:

```env
DISCORD_TOKEN=<Discord token>
DISCORD_PREFIX=_
GIPHY_TOKEN=<Giphy token>
```

Note: You can also use your hosting platform's method for setting environment variables.

Ensure you have a Discord bot token, then paste it into the first line as indicated.

Then, [obtain a Giphy API token](https://developers.giphy.com/docs/api) and paste it into the indicated space.

After that, run the following to install dependencies:

```bash
pip install -r requirements.txt
```

And, finally, run this to run the bot:

```bash
python dash/bot.py
```
