FROM python:3.11-alpine3.19
LABEL maintainer="hama_dev.com"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

ARG DEBUG=false
ENV PATH=/py/bin:$PATH
RUN python -m venv /py && \
    pip install --upgrade pip && \
    apk add --update --upgrade --no-cache postgresql-client && \
    apk add --update --upgrade --no-cache --virtual .tmp build-base postgresql-dev linux-headers

RUN pip install -r /requirements.txt && apk del .tmp && \
    if [ $DEBUG = "true" ]; then \
    pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp

COPY ./backend /backend
WORKDIR /backend

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]


