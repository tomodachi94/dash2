FROM alpine
MAINTAINER tomodachi94

COPY . /app
RUN apk update
RUN apk add python3 py3-pip
RUN pip install -r /app/requirements.txt
CMD ["/usr/bin/env", "python3", "/app/dash/__main__.py"]
