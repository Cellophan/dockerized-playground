# hadolint ignore=DL3006
#FROM docker as docker

# hadolint ignore=DL3007
FROM ubuntu:latest
ENV DOCKER_IMAGE="cell/playground"

#Basics
# hadolint ignore=DL3008
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends sudo vim git curl jq openssh-client ca-certificates gosu &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# hadolint ignore=DL3008
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends ca-certificates curl gnupg &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    install -m 0755 -d /etc/apt/keyrings &&\
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg &&\
    chmod a+r /etc/apt/keyrings/docker.gpg &&\
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null &&\
    apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install docker-ce-cli docker-buildx-plugin docker-compose-plugin &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#COPY --from=docker /usr/local/bin/docker /usr/local/bin/
COPY material/scripts     /usr/local/bin
COPY material/payload     /opt/payload
COPY material/lib         /lib
COPY material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

