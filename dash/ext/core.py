import lightbulb

loader = lightbulb.Loader()


@loader.command
class AboutCommand(
    lightbulb.SlashCommand, name="about", description="Tells you about the bot."
):
    @lightbulb.invoke
    async def invoke(self, ctx: lightbulb.Context) -> None:
        await ctx.respond(
            """
    Dash is a bot for the FTB Wiki's Discord.
    https://github.com/Tomodachi94/dash2
    """
        )
