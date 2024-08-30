# SPDX-FileCopyrightText: 2024 Tomodachi94
#
# SPDX-License-Identifier: MIT

import lightbulb

loader = lightbulb.Loader()


@loader.command
class AboutCommand(
    lightbulb.SlashCommand,
    name="core.command.about.name",
    description="core.command.about.desc",
    localize=True,
):
    @lightbulb.invoke
    async def invoke(self, ctx: lightbulb.Context) -> None:
        # FIXME: Translate response
        await ctx.respond(
            """
    Dash is a bot for the FTB Wiki's Discord.
    https://github.com/Tomodachi94/dash2
    """
        )
