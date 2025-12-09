# hadolint ignore=DL3006
#FROM docker as docker

# hadolint ignore=DL3007
FROM ubuntu:latest
ENV DOCKER_IMAGE="cell/playground"

#Basics
# hadolint ignore=DL3008
RUN sed -i '/:1000:/d' /etc/passwd &&\
    sed -i '/:1000:/d' /etc/group &&\
    rm -rvf /home/ubuntu

# hadolint ignore=DL3008
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends sudo vim git curl jq openssh-client ca-certificates gosu

# hadolint ignore=DL3008
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends ca-certificates curl gnupg &&\
    install -m 0755 -d /etc/apt/keyrings &&\
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&\
    chmod a+r /etc/apt/keyrings/docker.gpg &&\
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null &&\
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install docker-ce-cli docker-buildx-plugin docker-compose-plugin

#COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY material/scripts     /usr/local/bin
COPY material/payload     /opt/payload
COPY material/lib         /lib
COPY material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

