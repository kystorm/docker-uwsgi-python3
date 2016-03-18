############################################################
# Dockerfile to build uwsgi using python3 container images
# Based on Ubuntu 14.04.4
############################################################

FROM ubuntu:14.04.4
MAINTAINER ky.storm <ky.storm@163.com>

RUN apt-get update
RUN apt-get upgrade -y

# python 3.4 has already installed by os
RUN apt-get install -y \
            python3-pip

# clean apt-get
#RUN apt-get autoclean
RUN apt-get clean
#RUN apt-get autoremove

# install uwsgi
RUN pip3 install uwsgi
RUN pip3 install -U pip setuptools

# DEMO app here
COPY ./app /var/app
# install requirements, no need to use venv in docker
RUN pip3 install -r /var/app/requirements.txt


# configure your uwgis's config to .conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy again when onbuild
ONBUILD RUN rm -r /var/app
ONBUILD COPY ./app /var/app
# install requirements
ONBUILD RUN pip3 install -r /var/app/requirements.txt

# expose ports
EXPOSE 8080

CMD uwsgi --ini /var/app/uwsgi_config.ini