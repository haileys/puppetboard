FROM python:3.9-alpine

ENV PUPPETBOARD_SETTINGS docker_settings.py
RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/

# Workaround for https://github.com/benoitc/gunicorn/issues/2160
RUN apk --update --no-cache add libc-dev binutils

COPY requirements*.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements-docker.txt

COPY . /usr/src/app

CMD gunicorn -b 127.0.0.1:9080 --workers="${PUPPETBOARD_WORKERS:-1}" -e SCRIPT_NAME="${PUPPETBOARD_URL_PREFIX:-}" --access-logfile=- puppetboard.app:app
