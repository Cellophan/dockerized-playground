FROM debian:latest
MAINTAINER Cell <docker.cell@outer.systems>
LABEL gitrepo="https://github.com/Cellophan/DebSandBox.git"

#Basics
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy sudo vim git curl jq strace openssh-client openssh-server &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*
ADD material/bash.bashrc /etc/
ADD material/scripts     /usr/local/bin/
ADD material/skel        /etc/skel
ADD material/entrypoint  /
ENTRYPOINT ["/entrypoint"]

#Docker
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy curl socat &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    curl -sSL https://get.docker.com/ | sh

#Docker-compose
RUN curl -sSL https://github.com/docker/compose/releases/download/1.4.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose &&\
    chmod +x /usr/local/bin/docker-compose

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

#go
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy wget &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    wget -O /tmp/go.tar.gz --quiet https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz &&\
    tar -C /usr/local -xzf /tmp/go.tar.gz &&\
    rm /tmp/go.tar.gz &&\
    mkdir /go && chmod a+rw /go

ENV GOBIN /usr/local/go/bin
ENV PATH $PATH:$GOBIN 
ENV GOPATH /go

#Go tools
RUN echo godoc		&& go get golang.org/x/tools/cmd/godoc &&\
    echo goimports	&& go get golang.org/x/tools/cmd/goimports &&\
    echo oracle		&& go get golang.org/x/tools/cmd/oracle &&\
    echo gorename	&& go get golang.org/x/tools/cmd/gorename &&\
    echo gocode 	&& go get github.com/nsf/gocode &&\
    echo godef		&& go get github.com/rogpeppe/godef &&\
    echo golint		&& go get github.com/golang/lint/golint &&\
    echo errcheck	&& go get github.com/kisielk/errcheck &&\
    echo gotags		&& go get github.com/jstemmer/gotags &&\
    rm -r $GOPATH/*
     
#vim-go
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -qy vim-nox git exuberant-ctags &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/* &&\
    git clone --depth 1 https://github.com/gmarik/Vundle.vim.git /etc/skel/.vim/bundle/Vundle.vim &&\
    ln -s /etc/skel/.vim /root/ && vim -u /etc/skel/.vimrc +PluginInstall +qall
