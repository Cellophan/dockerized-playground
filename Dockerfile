FROM debian:8
MAINTAINER Cell <docker.cell@outer.systems>
ENV TERM screen

#Bascis
RUN apt-get update && \
    apt-get install -qy sudo vim

#X11
RUN apt-get install -qy x11-apps

RUN touch /etc/profile.d/placeholder.sh && chmod a+x /etc/profile.d/placeholder.sh
ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

