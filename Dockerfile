FROM debian:latest
MAINTAINER Cell <docker.cell@outer.systems>
ENV TERM screen

#Bascis
RUN apt-get update &&\
    apt-get install -qy sudo vim git curl jq openssh-client openssh-server &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#X11
RUN apt-get update &&\
    apt-get install -qy x11-apps &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Sublime text
#RUN apt-get update &&\
#    apt-get install -qy bzip2 wget &&\
#    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
#    wget --quiet --output-document=/tmp/sublime.bz2 http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2 &&\
#    tar -C /opt/ -xvjf /tmp/sublime.bz2 &&\
#    ln -s ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/local/bin/ &&\
#    rm /tmp/sublime.bz2

#Hugo
RUN apt-get update &&\
    apt-get install -qy wget &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    wget -O /tmp/hugo.deb --quiet https://github.com/spf13/hugo/releases/download/v0.14/hugo_0.14_amd64.deb &&\
    dpkg -i /tmp/hugo.deb &&\
    rm /tmp/hugo.deb

#Giantswarm
RUN curl -sSL http://downloads.giantswarm.io/swarm/clients/$(curl -sSL downloads.giantswarm.io/swarm/clients/VERSION)/swarm-$(curl -sSL downloads.giantswarm.io/swarm/clients/VERSION)-linux-amd64.tar.gz | tar xzv -C /usr/local/bin
ADD material/swarm.json /opt/

#Docker-compose
RUN curl -sSL https://github.com/docker/compose/releases/download/1.3.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose

#Entrypoint
ADD material/profile.sh /etc/profile.d/
ADD material/scripts    /usr/local/bin/
ADD material/entrypoint /entrypoint
ENTRYPOINT ["/entrypoint"]

