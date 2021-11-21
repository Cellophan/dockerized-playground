# hadolint ignore=DL3006
FROM docker as docker

FROM ubuntu:latest
ENV DOCKER_IMAGE="cell/playground"

#Basics
# hadolint ignore=DL3008
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends sudo vim git curl jq openssh-client ca-certificates gosu &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY material/scripts     /usr/local/bin
COPY material/payload     /opt/payload
COPY material/lib         /lib
COPY material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

