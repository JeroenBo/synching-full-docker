FROM ubuntu

MAINTAINER Jeroen Boonstra <jeroen@provider.nl>

RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties

# Needed for Golang
RUN add-apt-repository ppa:ubuntu-lxc/lxd-stable
RUN apt-get update && apt-get install -y \
        --no-install-recommends \
        ca-certificates \
        curl \
        git \
        golang \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*


# build all
ENV GOPATH=/build
RUN mkdir -p /build/src/github.com/syncthing; \
    cd /build/src/github.com/syncthing; \
    git clone https://github.com/syncthing/syncthing; \
    cd /build/src/github.com/syncthing/syncthing; \
    go run build.go


# Expose syncthing ports
EXPOSE 8384/tcp
EXPOSE 22000/tcp
EXPOSE 21027/udp
EXPOSE 22026/udp


# Copy binaries
RUN cp /build/src/github.com/syncthing/syncthing/bin/* /usr/local/bin/
RUN groupadd -r syncthing && useradd -r -m -g syncthing syncthing

USER syncthing
VOLUME /home/syncthing/
