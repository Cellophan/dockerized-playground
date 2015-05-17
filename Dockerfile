FROM debian:8
MAINTAINER Cell <docker.cell@outer.systems>
ENV TERM screen

#Bascis
RUN apt-get update && \
    apt-get install -qy sudo vim git curl

#X11
RUN apt-get install -qy x11-apps

#Docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN touch /etc/profile.d/placeholder.sh && chmod a+x /etc/profile.d/placeholder.sh
ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

