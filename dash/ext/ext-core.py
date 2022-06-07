import lightbulb

plugin = lightbulb.Plugin("Core")


@plugin.command()
@lightbulb.command("about", "Tells you about the bot.")
@lightbulb.implements(lightbulb.SlashCommand)
async def about(ctx):
    """
    Returns information about the bot.
    """
    await ctx.respond("""
    Dash is a bot for the FTB Wiki's Discord.
    https://github.com/Tomodachi94/dash2
    """)


def load(bot):
    bot.add_plugin(plugin)


def unload(bot):
    bot.remove_plugin(plugin)
