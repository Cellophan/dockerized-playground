FROM debian:latest
MAINTAINER Cell <maintainer.docker.cell@outer.systems>
ENV DOCKER_IMAGE="cell/debsandbox"

#Basics
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy sudo vim git curl jq strace openssh-client openssh-server &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Docker
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy curl socat &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    curl -sSL https://get.docker.com/ | sh

ADD material/scripts     /usr/local/bin
ADD material/payload     /opt/payload
ADD material/lib         /lib
ADD material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

