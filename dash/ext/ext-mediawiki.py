import os
import json
from mediawiki import MediaWiki

import lightbulb

MEDIAWIKI_API = os.environ["MEDIAWIKI_API"]
MEDIAWIKI_BASE_URL = os.environ["MEDIAWIKI_BASE_URL"]

plugin = lightbulb.Plugin("MediaWiki")
wiki = MediaWiki(url=MEDIAWIKI_API, user_agent="Dash2 v0.3.1 via pymediawiki: https://github.com/tomodachi94/dash2 ")

@plugin.command
@lightbulb.command("article", "Get information about an article.")
@lightbulb.implements(lightbulb.SlashCommandGroup)
async def article(ctx: lightbulb.Context) -> None:
    pass

def load(bot):
    bot.add_plugin(plugin)

def unload(bot):
    bot.remove_plugin(plugin)
