import os

import lightbulb
import mediawiki

MEDIAWIKI_BASE_URL = os.getenv("MEDIAWIKI_BASE_URL", "https://ftb.fandom.com/wiki/")

loader = lightbulb.Loader()
group = loader.command(lightbulb.Group("article", "Get information about an article."))


def _make_url(title: str, embed=False):
    url = os.path.join(MEDIAWIKI_BASE_URL, title)
    url = url.replace(" ", "_")
    if not embed:
        url = "<" + url + ">"

    return url


# @article.child
# @lightbulb.option("article_title", "The title of the target page.")
# @lightbulb.option(
#     "show_embeds",
#     "Toggle showing embeds. Disabled by default to prevent chat spam.",
#     required=False,
#     default=False)
# @lightbulb.command("links", "Retrieves a page's links to other pages.")
# @lightbulb.implements(lightbulb.SlashSubCommand)
# async def article_links(ctx: lightbulb.Context):
#     article_title = ctx.options.article_title
#     page = wiki.page(article_title)
#     links = page.links
#     out = []
#     for item in links:
#         item = _make_url(item, embed=ctx.options.show_embeds)
#         out.append(item)
#     # paginated = lightbulb.utils.pag.Paginator
#     # for item in out:
#     #     paginated._add_line(paginated, line=item)
#     # navigator = lutil.nav.ButtonNavigator(paginated.build_pages())
#     # await navigator.run(ctx)
#     out = "\n".join(out)
#     await ctx.respond(out)
#


showEmbedsOption = lightbulb.boolean(
    "show_embeds",
    "Toggle showing embeds. Disabled by default to prevent chat spam.",
    default=False,
)


@group.register
class ArticleRevisionCommand(
    lightbulb.SlashCommand,
    name="revision",
    description="Retrieves a page's current revision ID.",
):
    article_title = lightbulb.string("article_title", "The title of the target page.")
    show_embeds = showEmbedsOption

    @lightbulb.invoke
    async def invoke(self, ctx: lightbulb.Context, wiki: mediawiki.MediaWiki) -> None:
        article_title = self.article_title
        page = wiki.page(article_title)
        article_revision_id = page.revision_id
        url = _make_url(
            f"{article_title}?oldid={article_revision_id}", self.show_embeds
        )
        out = (
            f"The revision ID for the page `{article_title}` is "
            f"`{article_revision_id}`, available permanently at {url}."
        )
        await ctx.respond(out)


@group.register
class ArticleRandomCommand(
    lightbulb.SlashCommand,
    name="random",
    description="Shows a random article.",
):
    number = lightbulb.integer(
        "number", "The amount of random articles to retrieve. Defaults to 1."
    )
    show_embeds = showEmbedsOption

    @lightbulb.invoke
    async def invoke(self, ctx: lightbulb.Context, wiki: mediawiki.MediaWiki):
        random_amount = self.number
        show_embeds = self.show_embeds

        articles = wiki.random(pages=random_amount)

        if random_amount != 1:
            out = []
            for item in articles:
                item = _make_url(item, show_embeds)
                out.append(item)

            article_links = "\n".join(
                out
            )  # converts the list above into a newline-delimited string
        else:
            # pymediawiki.MediaWiki.random provides one variable (not in a list) if the random_amount is 1,
            # so disabling type-checking is okay here.
            out = articles  # type: ignore
            article_links = _make_url(out, show_embeds)  # type: ignore

        await ctx.respond(article_links)
