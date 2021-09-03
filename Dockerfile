FROM ubuntu:rolling as gosu

RUN apt-get update
# hadolint ignore=DL3008
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends wget git ca-certificates gcc
# hadolint ignore=DL3008
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends golang-go
ENV GOPATH=/tmp/go GOBIN=/usr/local/bin PATH=${PATH}:/usr/local/go/bin
RUN go get -u github.com/tianon/gosu

# hadolint ignore=DL3006
FROM docker as docker

FROM ubuntu:rolling
ENV DOCKER_IMAGE="cell/playground"

COPY --from=gosu   /usr/local/bin/* /usr/local/bin/
COPY --from=docker /usr/local/bin/docker /usr/local/bin/

#Basics
# hadolint ignore=DL3008
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends sudo vim git curl jq openssh-client ca-certificates &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

COPY material/scripts     /usr/local/bin
COPY material/payload     /opt/payload
COPY material/lib         /lib
COPY material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

