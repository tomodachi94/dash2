# Dash 2

A cleanroom rewrite of [Dash](https://github.com/tomodachi94/dash) on [Lightbulb](https://github.com/tandemdude/hikari-lightbulb) and [Hikari](https://github.com/hikari-py/hikari).

Changes are documented in [the changelog](CHANGELOG.md).

## Running

Create a file named `.env` in the root of the project.
Paste this into it:

```env
DISCORD_TOKEN=<token here>
DISCORD_PREFIX=_
```

Ensure you have a bot token, then paste it into the first line as indicated.

After that, run the following to install dependencies:

```bash
pip install -r requirements.txt
```

And, finally, run this to run the bot:

```bash
python dash/bot.py
```
