ARG BUILD_SERVER_NAME="irc.lame-network.local"

ARG UBUNTU_VERSION="noble"

FROM ubuntu:${UBUNTU_VERSION}

ENV ADMIN_EMAIL="no-reply@lame-network.local"

ENV SID="01A"

ENV SERVER_NAME="irc.lame-network.local"

ENV NETWORK_NAME="LameNet"

ENV STS_HOST="irc.lame-network.local"

ENV SASL_TARGET="service.lame-network.local"

ENV ADMIN_PASSWORD="changeme"

ENV COMMAND_RATE="128000"

ENV FAKE_LAG="off"

ENV HARD_SENDQ="1M"

ENV MAX_CHANS="256"

ENV PING_FREQ="64"

ENV RECVQ="8K"

ENV SOFT_SENDQ="8192"

ENV COMMAND_RATE_THRESHOLD="128"

ENV COMMAND_RATE_THRESHOLD_TIMEOUT="16"

ENV USE_CONN_FLOOD="no"

ENV USE_DNSBL="yes"

ENV USE_IDENT="no"

ENV GLOBAL_MAX="32"

ENV LOCAL_MAX="16"

ENV MAX_CONN_WARN="yes"

ENV DEFAULT_USER_MODES="+x"

ENV PORT="6667"

ENV RESOLVE_HOST_NAMES="yes"

ENV USE_CONNECT_BAN="no"

ENV SSL_USER_MODES="+xz"

ENV SSL_PORT="6697"

ENV AUTHENTICATED_USER_MODES="+xz"

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

ENV HELPER_VHOST="oper/helper.lame-network.local"

ENV SERVICES_ULINE="services.lame-network.local"

ENV WS_ORIGIN_ALLOW="irc.lame-network.local"

ENV LINK_RECV_PASSWORD="changeme"

ENV LINK_SEND_PASSWORD="changeme"

ENV LINK_TIMEOUT=3600

ENV CLOAK_KEY="changemechangemechangemechangeme"

ENV CLOAK_SUFFIX="hidden"

ENV BLOCK_AMSG_ACTION="killopers"

ENV BLOCK_AMSG_DELAY="3"

ENV BLOCK_HL_IGNORE_EXT_MESSAGE="yes"

ENV BLOCK_HL_MIN_LEN="50"

ENV BLOCK_HL_MIN_USER_NUM="10"

ENV BLOCK_HL_STRIP_COLOR="yes"

ENV BOT_MODE_FORCE_NOTICE="no"

ENV CHAN_FILTER_HIDE_MASK="yes"

ENV CHAN_FILTER_MAX_LEN="250"

ENV CHAN_FILTER_NOTIFY_USER="yes"

ENV CALLER_ID_COOL_DOWN="4m"

ENV CALLER_ID_MAX_ACCEPTS="256"

ENV CALLER_ID_TRACK_NICK="yes"

ENV CBAN_GLOB="yes"

ENV CHAN_HISTORY_BOTS="yes"

ENV CHAN_HISTORY_ENABLE_UMODE="yes"

ENV CHAN_HISTORY_MAX_LINES="64"

ENV CHAN_HISTORY_PREFIX_MSG="yes"

ENV OPER_CHANNEL_SNOMASK="DdRrtXxLlkKvgfFoO"

ENV CHAN_NAMES_ALLOW_RANGE="35,45-46"

ENV CHAN_NAMES_DENY_RANGE="1-47,58-64,91-96,123-255"

ENV CHANNELS_OPERS="4294967295"

ENV CHANNELS_USERS="4294967295"

ENV CONNECT_BAN_BOOT_WAIT="128"

ENV CONNECT_BAN_DURATION="64"

ENV CONNECT_BAN_V4_PREFIX_LEN="32"

ENV CONNECT_BAN_v6_PREFIX_LEN="128"

ENV CONNECT_BAN_SPLIT_WAIT="128"

ENV CONNECT_BAN_THRESHOLD="32"

ENV CTC_TAGS_ALLOW_CLIENT_ONLY_TAGS="no"

ENV DEAF_BYPASS_CHARS=""

ENV DEAF_BYPASS_CHARS_ULINE="!"

ENV DEAF_ENABLE_PRIV_DEAF=""

ENV DEAF_PRIV_DEAF_ULINE=""

ENV DELAY_MSG_ALLOW_NOTICE="yes"

ENV DISABLE_CHMODES=""

ENV DISABLE_COMMANDS=""

ENV DISABLE_FAKENONEXISTANT="no"

ENV DISABLE_USERMODES="w"

ENV HIDECHANS_AFFECTS_OPERS="yes"

ENV HOSTNAME_CHAR_MAP="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-_/0123456789,"

ENV HTTPD_TIMEOUT="8s"

ENV IDENT_PREFIX_UNQUERIED="yes"

ENV IDENT_TIMEOUT="2s"

ENV INSANE_HOSTMASKS="no"

ENV INSANE_IPMASKS="no"

ENV INSANE_NICKMASKS="no"

ENV INSANE_TRIGGER="95.5"

ENV INVITE_EXCEPTION_BYPASS_KEY="yes"

ENV IRCV3_ACCOUNT_NOTIFY="yes"

ENV IRCV3_AWAY_NOTIFY="yes"

ENV IRCV3_EXTENDED_JOIN="yes"

ENV JOIN_FLOOD_BOOT_WAIT="32s"

ENV JOIN_FLOOD_DURATION="32s"

ENV JOIN_FLOOD_SPLIT_WAIT="32s"

ENV KNOCK_NOTIFY="both"

ENV LIST_MAX_SIZE="256"

ENV MESSAGE_FLOOD_NOTICE="1.0"

ENV MESSAGE_FLOOD_PRIVMSG="1.0"

ENV MESSAGE_FLOOD_TAG_MSG="0.2"

ENV MONITOR_MAX_ENTRIES="256"

ENV MUTE_BAN_NOTIFY_USER="yes"

ENV NICK_DELAY="4s"

ENV NICK_DELAY_HINT="yes"

ENV NICK_FLOOD_DURATION="64s"

ENV NO_CTCP_ENABLE_UMODE="yes"

ENV OJOIN_NOTICE="yes"

ENV OJOIN_OP="yes"

ENV OJOIN_PREFIX="!"

ENV OPER_PREFIX="*"

ENV OPER_TO_SNOMASK="on"

ENV OVERRIDE_ENABLE_UMODE="yes"

ENV OVERRIDE_NOISY="yes"

ENV OVERRIDE_REQUIRE_KEY="yes"

ENV REMOVE_SUPPORT_NO_KICKS="yes"

ENV REPEAT_MAX_BACK_LOG="20"

ENV REPEAT_MAX_DISTANCE="50"

ENV REPEAT_MAX_LINES="20"

ENV REPEAT_MAX_TIME="0"

ENV REPEAT_MAX_SIZE="512"

ENV RLINE_ENGINE="pcre"

ENV RLINE_MATCH_ON_NICK_CHANGE="yes"

ENV RLINE_ZLINE_ON_MATCH="no"

ENV RESTRICT_CHANS_ALLOW_REGISTERED="no"

ENV SECURE_LIST_EXEMPT_REGISTERED="yes"

ENV SECURE_LIST_SHOW_MSG="yes"

ENV SECURE_LIST_WAIT_TIME="8s"

ENV SHOW_WHOIS_OPER_ONLY="no"

ENV SHOW_WHOIS_FROM_OPERS="yes"

ENV SHUN_AFFECT_OPERS="no"

ENV SHUN_ALLOW_CONNECT="no"

ENV SHUN_ALLOW_TAGS="no"

ENV SHUN_CLEANED_COMMANDS="AWAY PART QUIT"

ENV SHUN_ENABLED_COMMANDS="ADMIN OPER PING PONG QUIT PART JOIN"

ENV SHUN_NOTIFY_USER="yes"

ENV SILENCE_EXEMPT_ULINE="yes"

ENV SILENCE_MAX_ENTRIES="256"

ENV SSL_INFO_OPER_ONLY=""

ENV SSL_ENABLE_UMODE="no"

ENV SVS_HOLD_SILENT="no"

ENV TIMED_BANS_SEND_NOTICE="yes"

ENV WAIT_PONG_KILL_ON_BAD_REPLY="yes"

ENV WAIT_PONG_SEND_NOTICE="yes"

ENV WATCH_MAX="256"

ENV WHOWAS_GROUP_SIZE="10"

ENV WHOWAS_MAX_GROUPS="10000"

ENV WHOWAS_MAX_KEEP="32y"

ENV ZOMBIE_CLEAN_SPLIT="no"

ENV ZOMBIE_DIRTY_SPLIT="yes"

ENV ZOMBIE_MAX="100"

ENV ZOMBIE_SERVER_TIME="5m"

ENV AUDITORIUM_OP_CAN_SEE="no"

ENV AUDITORIUM_OPER_CAN_SEE="yes"

ENV AUDITORIUM_OP_VISIBLE="no"

RUN apt -y update

RUN apt -y install coreutils perl git automake autoconf build-essential libpcre2-dev rapidjson-dev libcurl4-gnutls-dev libargon2-dev libmaxminddb-dev libldap2-dev rapidjson-dev libmysqlclient-dev libmysqlclient-dev default-libmysqlclient-dev libpq-dev libre2-dev gnutls-dev libsqlite3-dev libmbedtls-dev libqrencode-dev libpcre3-dev libtre-dev pkg-config libwww-perl

RUN groupadd inspircd

RUN useradd --system --shell /bin/bash inspircd -g inspircd

WORKDIR /tmp

RUN git clone https://github.com/inspircd/inspircd.git

WORKDIR /tmp/inspircd

RUN git checkout -b master 7734b2e

RUN ./configure --gid inspircd --uid inspircd --development --prefix=/usr/local

RUN ./modulemanager list | awk '{print $1}' | xargs -i ./modulemanager install {} ; true

RUN make -j$(nproc) install

RUN mkdir -p /etc/inspircd/custom /var/lib/inspircd /etc/ssl/inspircd /var/log/inspircd /etc/inspircd/codepages

WORKDIR docs/conf/codepages

RUN cp ascii.example.conf /etc/inspircd/codepages/ascii.conf

RUN cat iso-8859-1.example.conf | grep -v "include" > /etc/inspircd/codepages/iso-8859-1.conf

RUN cat iso-8859-2.example.conf | grep -v "include" > /etc/inspircd/codepages/iso-8859-2.conf

RUN cat rfc1459.example.conf | grep -v "include" > /etc/inspircd/codepages/rfc1459.conf

RUN cat strict-rfc1459.example.conf | grep -v "include" > /etc/inspircd/codepages/strict-rfc1459.conf

ADD inspircd.conf /etc/inspircd

ADD modules.conf /etc/inspircd

ADD help.conf /etc/inspircd

ADD include.conf.example /etc/inspircd/custom/include.conf

RUN touch /etc/inspircd/motd.txt

RUN touch /etc/inspircd/oper.motd.txt

ADD GeoLite2-Country.mmdb /etc/inspircd

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
