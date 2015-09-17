FROM debian:latest
MAINTAINER Cell <docker.cell@outer.systems>
LABEL gitrepo="https://github.com/Cellophan/DebSandBox.git"

#Basics
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy sudo vim git curl jq strace openssh-client openssh-server &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#X11
#RUN apt-get update &&\
#    apt-get install -qy x11-apps &&\
#    apt-get clean -y && rm -rf /var/lib/apt/lists/*

#Sublime text
#RUN apt-get update &&\
#    apt-get install -qy bzip2 wget &&\
#    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
#    wget --quiet --output-document=/tmp/sublime.bz2 http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2 &&\
#    tar -C /opt/ -xvjf /tmp/sublime.bz2 &&\
#    ln -s ln -s /opt/Sublime\ Text\ 2/sublime_text /usr/local/bin/ &&\
#    rm /tmp/sublime.bz2

#go
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy wget &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    wget -O /tmp/go.tar.gz --quiet https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz &&\
    tar -C /usr/local -xzf /tmp/go.tar.gz &&\
    rm /tmp/go.tar.gz &&\
    ln -s /usr/local/go/bin/*  /usr/local/bin/

#vim-go-ide
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy vim-nox &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    git clone https://github.com/farazdagi/vim-go-ide.git /etc/skel/.vim_go_runtime

#Hugo
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy wget &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    wget -O /tmp/hugo.deb --quiet https://github.com/spf13/hugo/releases/download/v0.14/hugo_0.14_amd64.deb &&\
    dpkg -i /tmp/hugo.deb &&\
    rm /tmp/hugo.deb

#Giantswarm
RUN curl -sSL http://downloads.giantswarm.io/swarm/clients/$(curl -sSL downloads.giantswarm.io/swarm/clients/VERSION)/swarm-$(curl -sSL downloads.giantswarm.io/swarm/clients/VERSION)-linux-amd64.tar.gz | tar xzv -C /usr/local/bin
ADD material/swarm.json /opt/

#Docker
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy curl socat &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    curl -sSL https://get.docker.com/ | sh

#Docker-compose
RUN curl -sSL https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose

#Entrypoint
ADD material/bash.bashrc /etc/
ADD material/scripts     /usr/local/bin/
ADD material/skel        /etc/skel
ADD material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

