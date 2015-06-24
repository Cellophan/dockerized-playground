FROM debian:latest
MAINTAINER Cell <docker.cell@outer.systems>
ENV TERM screen

#Bascis
RUN apt-get update && \
    apt-get install -qy sudo vim git curl &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#X11
RUN apt-get update && \
    apt-get install -qy x11-apps &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Giantswarm
RUN curl -sSL http://downloads.giantswarm.io/swarm/clients/$(curl -0 downloads.giantswarm.io/swarm/clients/VERSION)/swarm-$(curl -0 downloads.giantswarm.io/swarm/clients/VERSION)-linux-amd64.tar.gz | tar xzv -C /usr/local/bin

#Docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.3.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose

#Entrypoint
ADD material/profile.sh /etc/profile.d/
ADD material/scripts    /usr/local/bin/
ADD material/entrypoint /entrypoint
RUN chmod a+x /entrypoint
ENTRYPOINT ["/entrypoint"]

