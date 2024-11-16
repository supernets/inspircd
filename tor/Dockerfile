ARG UBUNTU_VERSION="noble"

FROM ubuntu:${UBUNTU_VERSION}

RUN apt -y update

RUN apt -y install tor

RUN groupadd docker-tor

RUN useradd --system --shell /bin/bash docker-tor -g docker-tor

RUN mkdir -p /var/lib/tor/ -p /etc/tor

ADD torrc /etc/tor

RUN chown -R docker-tor:docker-tor /etc/tor /var/lib/tor

VOLUME /var/lib/tor

USER docker-tor

CMD tor -f /etc/tor/torrc
