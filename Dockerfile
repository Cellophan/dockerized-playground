FROM ubuntu:latest as gosu

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy --no-install-recommends wget git ca-certificates gcc
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qy golang-go
ENV GOPATH=/tmp/go GOBIN=/usr/local/bin PATH=${PATH}:/usr/local/go/bin
RUN go get -u github.com/tianon/gosu

FROM docker as docker

FROM ubuntu:latest
ENV DOCKER_IMAGE="cell/playground"

COPY --from=gosu   /usr/local/bin/* /usr/local/bin/
COPY --from=docker /usr/local/bin/docker /usr/local/bin/

#Basics
RUN apt update &&\
    DEBIAN_FRONTEND=noninteractive apt install -qy --no-install-recommends sudo vim git curl jq openssh-client ca-certificates &&\
    apt clean -y && rm -rf /var/lib/apt/lists/*

COPY material/scripts     /usr/local/bin
COPY material/payload     /opt/payload
COPY material/lib         /lib
COPY material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

