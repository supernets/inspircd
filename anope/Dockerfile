FROM ubuntu:latest

ARG BUILD_SERVER_NAME="services.lame-network.local"

RUN apt -y update

RUN apt -y install coreutils cmake perl git automake autoconf build-essential libpcre2-dev rapidjson-dev libcurl4-gnutls-dev libargon2-dev libmaxminddb-dev libldap2-dev rapidjson-dev libmysqlclient-dev libmysqlclient-dev default-libmysqlclient-dev libpq-dev libre2-dev gnutls-dev libsqlite3-dev libmbedtls-dev libqrencode-dev libpcre3-dev libtre-dev pkg-config libwww-perl libidn-dev libpasswdqc-dev libcrack2-dev libperl-dev libsodium-dev cracklib-runtime libcrypt-cracklib-perl sendmail

RUN groupadd anope

RUN useradd --system --shell /bin/bash anope -g anope

WORKDIR /tmp

RUN git clone https://github.com/anope/anope.git

WORKDIR /tmp/anope/modules

RUN ls -1 extra/*.cpp | xargs -i ln -s {}

WORKDIR /tmp/anope

RUN cmake -DINSTDIR:STRING=/usr/local -DRUNGROUP:STRING=anope -DDEFUMASK:STRING=007 -DCMAKE_BUILD_TYPE:STRING=RELEASE -B /tmp/anope/build /tmp/anope

WORKDIR /tmp/anope/build

RUN make -j$(nproc) 

RUN make install

RUN mkdir -p /etc/anope -p /etc/ssl/anope -p /var/log/anope -p /var/lib/anope

ADD anope.conf /etc/anope

ADD include.default.conf /etc/anope/include.conf

RUN openssl genrsa -out /etc/ssl/anope/server.key

RUN openssl req -new -key /etc/ssl/anope/server.key -out /etc/ssl/anope/server.csr \
    -subj "/C=US/ST=Washington/L=Seattle/O=LameNetwork/OU=IT Department/CN=$BUILD_SERVER_NAME"

RUN openssl x509 -req -days 365 -in /etc/ssl/anope/server.csr -signkey /etc/ssl/anope/server.key -out /etc/ssl/anope/server.crt

RUN chown -R anope:anope /etc/anope /etc/ssl/anope /var/log/anope /var/lib/anope

WORKDIR /

VOLUME /var/lib/anope

VOLUME /etc/ssl/anope

VOLUME /var/log/anope

USER anope

ENTRYPOINT ["/usr/local/bin/anope", "--nofork", "--config=/etc/anope/anope.conf", "--dbdir=/var/lib/anope", "--logdir=/var/log/anope", "--moduledir=/usr/local/modules"]
