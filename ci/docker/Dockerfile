ARG BASE_TAG

FROM debian:${BASE_TAG}

USER root
WORKDIR /usr/app
ADD https://get.datree.io .
RUN apt-get update && apt-get --yes install curl bash unzip sudo &&\ 
    curl https://get.datree.io  > datree.sh &&\
    chmod 777 datree.sh
USER 536