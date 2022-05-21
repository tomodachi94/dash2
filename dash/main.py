import dotenv
import os
import json

import hikari
import lightbulb

# environment
dotenv.load_dotenv()
DISCORD_TOKEN = os.environ["DISCORD_TOKEN"]
DISCORD_PREFIX = os.environ.get("DISCORD_PREFIX", "_")
GIPHY_TOKEN = os.environ["GIPHY_TOKEN"]

bot = lightbulb.BotApp(token=DISCORD_TOKEN, prefix=DISCORD_PREFIX, logs="INFO")

bot.load_extensions_from("./ext/")

bot.run()
