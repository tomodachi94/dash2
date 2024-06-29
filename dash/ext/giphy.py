import os
import json

import lightbulb
from ezgiphy import GiphyPublicAPI

loader = lightbulb.Loader()

GIPHY_TOKEN = os.environ["GIPHY_TOKEN"]


@loader.command
class BunnyCommand(
    lightbulb.SlashCommand, name="bunny", description="Sends a bunny GIF."
):
    @lightbulb.invoke
    async def invoke(self, ctx: lightbulb.Context) -> None:
        giphy = GiphyPublicAPI(GIPHY_TOKEN)
        tag = "rabbit"

        data = giphy.random(tag=tag, rating="g", limit=1)
        data = json.loads(data)
        data = data["data"]
        embed_url = data["embed_url"]
        await ctx.respond(embed_url)
