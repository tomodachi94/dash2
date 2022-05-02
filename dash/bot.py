import dotenv
import os
import json

from ezgiphy import GiphyPublicAPI
import hikari
import lightbulb

# environment
dotenv.load_dotenv()
DISCORD_TOKEN = os.environ["DISCORD_TOKEN"]
DISCORD_PREFIX = os.environ.get("DISCORD_PREFIX", "_")
GIPHY_TOKEN = os.environ["GIPHY_TOKEN"]

bot = lightbulb.BotApp(token=DISCORD_TOKEN, prefix=DISCORD_PREFIX, logs="INFO")


@bot.command()
@lightbulb.command("about", "Tells you about the bot.")
@lightbulb.implements(lightbulb.SlashCommand)
async def about(ctx):
    """
    Returns information about the bot.
    """
    await ctx.respond(
        """
    Dash is a bot for the FTB Wiki's Discord.
    https://github.com/Tomodachi94/dash2
    """
    )


@bot.command()
@lightbulb.command("bunny", "Sends a bunny GIF.")
@lightbulb.implements(lightbulb.PrefixCommand, lightbulb.SlashCommand)
async def bunny(ctx: lightbulb.Context):
    """
    Sends a bunny GIF using the giphy API.
    """
    giphy = GiphyPublicAPI(GIPHY_TOKEN)
    tag = 'bunny'

    data = giphy.random(tag=tag, rating="g", limit=1)
    data = json.loads(data)
    data = data["data"]
    embed_url = data["embed_url"]
    await ctx.respond(embed_url)


bot.run()
