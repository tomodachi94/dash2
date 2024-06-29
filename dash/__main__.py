#!/usr/bin/env python3
"""
Core bot code. Loads in extensions and initializes bot instance.
"""

import os

import hikari
import lightbulb

import dash.ext

DISCORD_TOKEN = os.environ["DISCORD_TOKEN"]
bot = hikari.GatewayBot(DISCORD_TOKEN)
client = lightbulb.client_from_app(bot)


@bot.listen(hikari.StartingEvent)
async def on_starting(_: hikari.StartingEvent) -> None:
    await client.load_extensions_from_package(dash.ext)
    await client.start()


def main():
    bot.run()
