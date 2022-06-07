import os
import json
from mediawiki import MediaWiki

import lightbulb

MEDIAWIKI_API = os.environ["MEDIAWIKI_API"]
MEDIAWIKI_BASE_URL = os.environ["MEDIAWIKI_BASE_URL"]

plugin = lightbulb.Plugin("MediaWiki")
wiki = MediaWiki(
    url=MEDIAWIKI_API,
    user_agent=
    "Dash2 v0.3.1 via pymediawiki: https://github.com/tomodachi94/dash2 ")


def _make_url(title: str, embed=False):
    url = os.path.join(MEDIAWIKI_BASE_URL, title)
    url = url.replace(" ", "_")
    if not embed:
        url = "<" + url + ">"

    return url


@plugin.command
@lightbulb.command("article", "Get information about an article.")
@lightbulb.implements(lightbulb.SlashCommandGroup)
async def article(ctx: lightbulb.Context) -> None:
    pass


@article.child
@lightbulb.option("article_title", "The title of the target page.")
@lightbulb.option(
    "show_embeds",
    "Toggle showing embeds. Disabled by default to prevent chat spam.",
    required=False,
    default=False)
@lightbulb.command("links", "Retrieves a page's links to other pages.")
@lightbulb.implements(lightbulb.SlashSubCommand)
async def article_links(ctx: lightbulb.Context):
    article_title = ctx.options.article_title
    page = wiki.page(article_title)
    links = page.links
    out = []
    for item in links:
        item = _make_url(item, embed=embed)
        out.append(item)
    # paginated = lightbulb.utils.pag.Paginator
    # for item in out:
    #     paginated._add_line(paginated, line=item)
    # navigator = lutil.nav.ButtonNavigator(paginated.build_pages())
    # await navigator.run(ctx)
    out = "\n".join(out)
    await ctx.respond(out)


@article.child
@lightbulb.option("article_title", "The title of the target page.")
@lightbulb.option(
    "show_embeds",
    "Toggle showing embeds. Disabled by default to prevent chat spam.",
    required=False,
    default=False)
@lightbulb.command("revision", "Retrieves a page's current revision ID.")
@lightbulb.implements(lightbulb.SlashSubCommand)
async def article_revision(ctx: lightbulb.Context):
    article_title = ctx.options.article_title
    page = wiki.page(article_title)
    article_revision_id = page.revision_id
    url = _make_url(f"{article_title}?oldid={article_revision_id}")
    out = f"The revision ID for the page `{article_title}` is `{article_revision_id}`, available permanently at {url}."
    await ctx.respond(out)


@article.child
@lightbulb.option(
    "show_embeds",
    "Toggle showing embeds. Disabled by default to prevent chat spam.",
    required=False,
    default=False)
@lightbulb.option("number",
                  "The amount of random articles to retrieve. Defaults to 1.",
                  type=int,
                  default=1)
@lightbulb.command("random", "Shows a random article.")
@lightbulb.implements(lightbulb.SlashSubCommand)
async def article_random(ctx: lightbulb.Context):
    random_amount = ctx.options.number
    show_embeds = ctx.options.show_embeds

    articles = wiki.random(pages=random_amount)

    if random_amount != 1:
        out = []
        for item in articles:
            item = _make_url(item, show_embeds)
            out.append(item)

        out = "\n".join(
            out)  # converts the list above into a newline-delimited string
    else:
        out = articles
        out = _make_url(out, show_embeds)

    await ctx.respond(out)


def load(bot):
    bot.add_plugin(plugin)


def unload(bot):
    bot.remove_plugin(plugin)
