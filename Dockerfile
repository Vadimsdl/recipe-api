FROM python:3.9-alpine3.13
#label - who make this, you can write here (website, name of user, etc.)
LABEL maintainer="Recipe"

#it tells Python that you don't want to buffer the outbut  the output Pythont will be printed directly to the console
ENV PYTHONUNBUFFERED 1

#copy our requirements on text file from our local machine to forward (file requirements.txt copy in Docker image)
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
#then we copy our directory app 
COPY ./app /app
#where by default will be run the commands
WORKDIR /app
EXPOSE 8000

#ths runs a command on the alpine image that we are using when we're building our image
#python -m venv /py && \  - create a new virtual envirement for use to store our dependencies 
#ALL USING FOR VIRTUALL ENVIREMENT
#adduser - use for create our user for container Docker
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

#user wich we switch 
USER django-user
