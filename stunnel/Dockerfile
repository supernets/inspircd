ARG UBUNTU_VERSION="noble"

FROM ubuntu:${UBUNTU_VERSION}

RUN apt -y update

RUN apt -y install stunnel

ADD stunnel.conf /etc/stunnel/stunnel.conf

CMD stunnel
