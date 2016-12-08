FROM debian:latest
ENV DOCKER_IMAGE="cell/debsandbox"

#Basics
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy sudo vim git curl jq strace openssh-client openssh-server &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Docker
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy curl socat &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    curl -fsSL https://test.docker.com/ | sh

# From https://github.com/tianon/gosu
ENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true
#    && apt-get purge -y --auto-remove ca-certificates wget


ADD material/scripts     /usr/local/bin
ADD material/payload     /opt/payload
ADD material/lib         /lib
ADD material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

