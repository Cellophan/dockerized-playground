FROM ubuntu as gosu

# From https://github.com/tianon/gosu
ENV GOSU_VERSION 1.9
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget dirmngr && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget

FROM ubuntu as docker
RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt install -qy --no-install-recommends curl ca-certificates
RUN curl -sSL -o /usr/local/bin/docker https://master.dockerproject.org/linux/x86_64/docker
RUN chmod a+x /usr/local/bin/docker


FROM ubuntu:16.10
ENV DOCKER_IMAGE="cell/playground"

COPY --from=gosu   /usr/local/bin/* /usr/local/bin/
COPY --from=docker /usr/local/bin/* /usr/local/bin/

#Basics
RUN apt update &&\
    DEBIAN_FRONTEND=noninteractive apt install -qy sudo vim git curl jq strace openssh-client openssh-server &&\
    apt clean -y && rm -rf /var/lib/apt/lists/*

COPY material/scripts     /usr/local/bin
COPY material/payload     /opt/payload
COPY material/lib         /lib
COPY material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

