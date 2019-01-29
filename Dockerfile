FROM python:2.7-alpine

RUN apk add --update \
    python \
    python-dev \
    linux-headers \
    libc-dev \
    py-pip \
    gcc \
    && rm -rf /var/cache/apk/*

COPY requirements.txt /tmp
RUN pip install -r /tmp/requirements.txt

COPY ./app /app
WORKDIR /app
EXPOSE 5000 
ENTRYPOINT ["python", "app.py"]

