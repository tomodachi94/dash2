FROM alpine
MAINTAINER tomodachi94

# ARG DISCORD_TOKEN
# ARG GIPHY_TOKEN
# ARG DISCORD_PREFIX=_
# ARG MEDIAWIKI_API=https://ftb.fandom.com/api.php
# ARG MEDIAWIKI_BASE_URL=https://ftb.fandom.com/wiki/

# ENV DISCORD_TOKEN=${DISCORD_TOKEN}
# ENV GIPHY_TOKEN=${GIPHY_TOKEN}
# ENV DISCORD_PREFIX=${DISCORD_PREFIX}
# ENV MEDIAWIKI_API=${MEDIAWIKI_API}
# ENV MEDIAWIKI_BASE_URL=${MEDIAWIKI_BASE_URL}

COPY . /app
RUN apk update
RUN apk add python3 py3-pip
RUN pip install -r /app/requirements.txt
CMD ["/usr/bin/env", "python3", "/app/dash/__main__.py"]
