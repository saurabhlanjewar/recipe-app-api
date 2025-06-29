# FROM python:3.9-alpine3.13
FROM python:3.9-alpine3.21

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /temp/requirements.txt
COPY ./requirements.dev.txt /temp/requirements.dev.txt

COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --no-cache postgresql-client &&\
    apk add --no-cache --virtual .build-deps \
        build-base \
        musl-dev \
        postgresql-dev && \
    /py/bin/pip install -r /temp/requirements.txt && \
    if [ $DEV = "true" ]; then \
        /py/bin/pip install -r /temp/requirements.dev.txt; \
    fi && \
    rm -rf /temp && \
    apk del .build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"
USER django-user
