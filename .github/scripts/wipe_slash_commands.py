"""
Script to delete all registered slash commands from Discord's servers. Borrowed from davfsa at
https://discord.com/channels/574921006817476608/700378161526997003/936731890549944370
in the Hikari Discord server: https://discord.gg/Jx4cNGG
"""

import asyncio
import os

import hikari

DISCORD_TOKEN = os.environ["DISCORD_TOKEN"]
DISCORD_APP_ID = int(os.environ["DISCORD_APP_ID"])

rest = hikari.RESTApp()


async def main():
    async with rest.acquire(DISCORD_TOKEN, hikari.TokenType.BOT) as client:
        await client.set_application_commands(DISCORD_APP_ID, [])


asyncio.run(main())
