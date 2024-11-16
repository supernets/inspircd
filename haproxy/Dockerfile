ARG UBUNTU_VERSION="noble"

FROM ubuntu:${UBUNTU_VERSION}

RUN apt -y update

RUN apt -y install haproxy

RUN groupadd docker-haproxy

RUN useradd --system --shell /bin/bash docker-haproxy -g docker-haproxy

RUN mkdir -p /var/lib/haproxy/ -p /etc/haproxy

ADD haproxy.cfg /etc/haproxy

RUN chown -R docker-haproxy:docker-haproxy /etc/haproxy /var/lib/haproxy

VOLUME /var/lib/haproxy

USER docker-haproxy

CMD haproxy -f /etc/haproxy/haproxy.cfg
