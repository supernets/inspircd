FROM ubuntu:latest

ARG BUILD_SERVER_NAME="irc.lame-network.local"

ENV ADMIN_EMAIL="no-reply@lame-netwoork.local"

ENV SID="01A"

ENV SERVER_NAME="irc.lame-network.local"

ENV NETWORK_NAME="LameNet"

ENV STS_HOST="irc.lame-network.local"

ENV SASL_TARGET="service.lame-network.local"

ENV ADMIN_PASSWORD="changeme"

ENV COMMAND_RATE="128000"

ENV FAKE_LAG="on"

ENV HARD_SENDQ="1M"

ENV MAX_CHANS="256"

ENV PING_FREQ="64"

ENV RECVQ="8K"

ENV SOFT_SENDQ="8192"

ENV COMMAND_RATE_THRESHOLD="128"

ENV COMMAND_RATE_THRESHOLD_TIMEOUT="16"

ENV USE_CONN_FLOOD="yes"

ENV USE_DNSBL="yes"

ENV USE_IDENT="no"

ENV GLOBAL_MAX="32"

ENV LOCAL_MAX="16"

ENV MAX_CONN_WARN="yes"

ENV DEFAULT_USER_MODES="+xWz"

ENV PORT="6667"

ENV RESOLVE_HOST_NAMES="yes"

ENV USE_CONNECT_BAN="yes"

ENV SSL_USER_MODES="+xWz"

ENV SSL_PORT="6697"

ENV AUTHENTICATED_USER_MODES="+xwWz"

ENV SERVER_SSL_PORT="7000"

ENV OPER_CHANNEL="#oper"

ENV HTTP_ACL_PASSWORD="changeme"

ENV HTTP_ACL_USERNAME="lame-network"

ENV SERVICE_CHANNEL="#services"

ENV HELP_CHANNEL="#help"

ENV MAX_AWAY="256"

ENV MAX_CHAN="31"

ENV MAX_GECOS="256"

ENV MAX_HOST="64"

ENV MAX_IDENT="16"

ENV MAX_KICK="256"

ENV MAX_MODES="32"

ENV MAX_NICK="31"

ENV MAX_QUIT="256"

ENV MAX_TOPIC="256"

ENV ALLOW_MISMATCH="yes"

ENV ALLOW_ZERO_LIMIT="yes"

ENV ANNOUNCE_TS="yes"

ENV CYCLE_HOST_TS="yes"

ENV CYCLE_HOST_FROM_USER="no"

ENV HOST_IN_TOPIC="yes"

ENV INVITE_BYPASS_MODES="yes"

ENV MODES_IN_LIST="yes"

ENV NO_SNOTICE_STACK="yes"

ENV PING_WARNING="8"

ENV PREFIX_PART="&quot;"

ENV PREFIX_QUIT="QUIT: &quot;"

ENV SERVER_PING_FREQ="8"

ENV SPLIT_WHOIS="no"

ENV SUFFIX_PART="&quot;"

ENV SUFFIX_QUIT="&quot;"

ENV SYNTAX_HINTS="yes"

ENV XLINE_MESSAGE="DEAUTHORIZED"

ENV CLONES_ON_CONNECT="yes"

ENV NET_BUFFER_SIZE="10240"

ENV QUIET_BURSTS="yes"

ENV SOFT_LIMIT="102400"

ENV SO_MAX_CONN="1024"

ENV TIME_SKIP_WARN="2s"

ENV ROLE_PLAY_VHOST="rp.lame-network.local"

ENV CUSTOM_VERSION="LameNetworkIRCd v3.14 (final)"

ENV FLAT_LINKS="no"

ENV GENERIC_OPER="yes"

ENV HIDE_BANS="no"

ENV HIDE_MODES="no"

ENV HIDE_SPLITS="yes"

ENV HIDE_ULINES="no"

ENV MAX_TARGETS="16"

ENV RESTRICT_BANNED_USERS="yes"

ENV USER_STATS="Pu"

ENV NET_ADMIN_VHOST="oper/admin.lame-network.local"

ENV GLOBAL_OP_VHOST="oper/op.lame-network.local"

ENV HOPM_VHOST="oper/hopm.lame-network.local"

ENV HELPER_VHOST="oper/helper.lame-network.local"

ENV SERVICES_ULINE="services.lame-network.local"

ENV WS_ORIGIN_ALLOW="irc.lame-network.local"

ENV DEFAULT_BLOCK_HOST_MASK="*@*"

ENV LINK_RECV_PASSWORD="changeme"

ENV LINK_SEND_PASSWORD="changeme"

ENV LINK_TIMEOUT=3600

RUN apt -y update

RUN apt -y install perl git automake autoconf build-essential libpcre2-dev rapidjson-dev libcurl4-gnutls-dev libargon2-dev libmaxminddb-dev libldap2-dev rapidjson-dev libmysqlclient-dev libmysqlclient-dev default-libmysqlclient-dev libpq-dev libre2-dev gnutls-dev libsqlite3-dev libmbedtls-dev libqrencode-dev libpcre3-dev libtre-dev pkg-config libwww-perl

RUN groupadd inspircd

RUN useradd --system --shell /bin/bash inspircd -g inspircd

WORKDIR /tmp

RUN git clone https://github.com/inspircd/inspircd.git

WORKDIR /tmp/inspircd

RUN ./configure --gid inspircd --uid inspircd --development --prefix=/usr/local

RUN ./modulemanager list | awk '{print $1}' | xargs -i ./modulemanager install {} ; true

RUN make -j$(nproc) install

RUN mkdir -p /etc/inspircd /var/lib/inspircd /etc/ssl/inspircd /var/log/inspircd

ADD inspircd.conf /etc/inspircd

ADD include.default.conf /etc/inspircd/include.conf

ADD GeoLite2-ASN.mmdb /etc/inspircd

RUN touch /etc/inspircd/motd.txt

RUN touch /etc/inspircd/oper.motd.txt 

RUN openssl genrsa -out /etc/ssl/inspircd/server.key

RUN openssl req -new -key /etc/ssl/inspircd/server.key -out /etc/ssl/inspircd/server.csr \
    -subj "/C=US/ST=Washington/L=Seattle/O=LameNetwork/OU=IT Department/CN=$BUILD_SERVER_NAME"

RUN openssl x509 -req -days 365 -in /etc/ssl/inspircd/server.csr -signkey /etc/ssl/inspircd/server.key -out /etc/ssl/inspircd/server.crt

RUN chown -R inspircd:inspircd /etc/inspircd /etc/ssl/inspircd /var/lib/inspircd /var/log/inspircd

VOLUME /etc/ssl/inspircd

VOLUME /var/lib/inspircd

VOLUME /var/log/inspircd

USER inspircd

WORKDIR /

CMD /usr/local/bin/inspircd -c /etc/inspircd/inspircd.conf -F 
