import dotenv
import os
import pathlib
import json

import hikari
import lightbulb

# environment
dotenv.load_dotenv()
DISCORD_TOKEN = os.environ["DISCORD_TOKEN"]
DISCORD_PREFIX = os.environ.get("DISCORD_PREFIX", "_")
GIPHY_TOKEN = os.environ["GIPHY_TOKEN"]

DASH_PATH = os.path.realpath(__file__)
DASH_PATH = os.path.dirname(DASH_PATH)
DASH_EXT_PATH = os.path.join(DASH_PATH, "ext")
print("Dash path: ", DASH_PATH)
print("Dash ext path: ", DASH_EXT_PATH)

bot = lightbulb.BotApp(token=DISCORD_TOKEN, prefix=DISCORD_PREFIX, logs="INFO")

bot.load_extensions_from(DASH_EXT_PATH)

bot.run()
