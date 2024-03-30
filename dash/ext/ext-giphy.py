import os
import json

import lightbulb
from ezgiphy import GiphyPublicAPI

plugin = lightbulb.Plugin("Giphy")

GIPHY_TOKEN = os.environ["GIPHY_TOKEN"]


@plugin.command()
@lightbulb.command("bunny", "Sends a bunny GIF.")
@lightbulb.implements(lightbulb.PrefixCommand, lightbulb.SlashCommand)
async def bunny(ctx: lightbulb.Context):
    """
    Sends a bunny GIF using the giphy API.
    """
    giphy = GiphyPublicAPI(GIPHY_TOKEN)
    tag = "rabbit"

    data = giphy.random(tag=tag, rating="g", limit=1)
    data = json.loads(data)
    data = data["data"]
    embed_url = data["embed_url"]
    await ctx.respond(embed_url)


def load(bot):
    bot.add_plugin(plugin)


def unload(bot):
    bot.remove_plugin(plugin)
