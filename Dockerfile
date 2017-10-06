
FROM python:2.7-slim

# FROM python:2.7-slim is from
#  https://hub.docker.com/_/python/
#  https://github.com/docker-library/python/blob/d3c5f47b788adb96e69477dadfb0baca1d97f764/2.7/jessie/slim/Dockerfile


MAINTAINER Nick Janetakis <nick.janetakis@gmail.com>

RUN apt-get update && apt-get install -qq -y build-essential libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends
# RUN a shell script or some command
# -qq quiet mode
# -y force "yes" so it is hands free
# build-essential : get any essentials to compile anything
# libpq-dev : library to communicate with postgres
# postgresql-client-9.4 : library for postgres
# --fix-missing 
# --no-install-recommends


ENV INSTALL_PATH /mobydock
# PATH variable where the path will be installed within the container
# "/mobydock" - the service that will be built within the container.
#

RUN mkdir -p $INSTALL_PATH
# 
# 

WORKDIR $INSTALL_PATH
# Every command that will be executed under WORKDIR
#  will be within the context of the install path


COPY requirements.txt requirements.txt
# COPY the file "requirements.txt" to the same file on the Docker image
# 

RUN pip install -r requirements.txt
# This will be performed within the context of the /mobydock directory.
# 

COPY . .
# COPY all of the files from the "mobydock" folder to the Docker image
# This is separate from the above so as to take advantage of the casheing from Docker
# 

VOLUME ["static"]
# Set up a volume for the static content (so that nginX can read from it)
# nginX will serve all of the static content instead of Flask
# 


CMD gunicorn -b 0.0.0.0:8000 "mobydock.app:create_app()"
# The default command is to run the gunicorn server
# The Gunicorn "Green Unicorn" is a Python Web Server Gateway Interface (WSGI) 
# HTTP server. It is a pre-fork worker model, ported from Ruby's Unicorn project. 
# The Gunicorn server is broadly compatible with a number of web frameworks, 
# simply implemented, light on server resources and fairly fast.
# -b 0.0.0.0:8000 :> listen on any host, port 8000
#  mobydock.app:create_app() :> inside the mobydock.app file will be the 
#  create_app() function (will adhere to the factory pattern)
#
