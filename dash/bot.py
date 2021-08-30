import lightbulb
import dotenv
import os
import logging

# environment
dotenv.load_dotenv()
DISCORD_TOKEN = os.environ["DISCORD_TOKEN"]
DISCORD_PREFIX = os.environ.get("DISCORD_PREFIX", "_")

bot = lightbulb.Bot(token=DISCORD_TOKEN, prefix=DISCORD_PREFIX, logs="INFO")

@bot.command()
async def about(ctx):
    await ctx.respond(
    """
    Dash is a bot for the FTB Wiki's Discord.
    https://github.com/Tomodachi94/dash2
    """)

bot.run()