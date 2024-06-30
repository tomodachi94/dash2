#!/usr/bin/env python3
"""
Core bot code. Loads in extensions and initializes bot instance.
"""

import os

import hikari
import lightbulb

import mediawiki

import dash.ext
from dash import __version__

DISCORD_TOKEN = os.environ["DISCORD_TOKEN"]
MEDIAWIKI_API = os.getenv("MEDIAWIKI_API", "https://ftb.fandom.com/api.php")
bot = hikari.GatewayBot(DISCORD_TOKEN)
client = lightbulb.client_from_app(bot)


@bot.listen(hikari.StartingEvent)
async def on_starting(_: hikari.StartingEvent) -> None:
    await client.load_extensions_from_package(dash.ext)
    client.di.register_dependency(
        mediawiki.MediaWiki,
        lambda: mediawiki.MediaWiki(
            url=MEDIAWIKI_API,
            user_agent=(
                f"Dash2 v{__version__} via pymediawiki: "
                "https://github.com/tomodachi94/dash2"
            ),
        ),
    )
    await client.start()


def main():
    bot.run()
