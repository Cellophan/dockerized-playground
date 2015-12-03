FROM debian:latest
MAINTAINER Cell <maintainer.docker.cell@outer.systems>

#Basics
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy sudo vim git curl jq strace openssh-client openssh-server &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
ADD material/scripts     /usr/local/bin/
ADD material/payload     /opt/payload/
ADD material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

#Docker
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy curl socat &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    curl -sSL https://get.docker.com/ | sh


