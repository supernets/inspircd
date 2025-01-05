# Getting started 
This docker configuration relies on the host network driver meaning it doesn't setup any internal networks or even a separate NetNS. Your 
mileage may vary if you change the intended network driver for Docker.

## Hub
- copy `config.env.example` to `config.env` and edit 
- copy `include.conf.example` to `custom/include.conf` and edit (don't delete) as much as possible for now

### Internal TLS
The following steps describe how to setup `easyrsa3` for internal TLS. This step is necessary regardless of whether you intended to use
issued certificates for leaf servers because it provides TLS encryption between the hub and it's leaf servers and between services. Refer
to the external TLS section for leaf servers for more info. To bootstrap internal TLS with an `easyrsa3` CA perform the following:

- cd to `easyrsa3` directory
- `./easyrsa init-pki`
- `./easyrsa build-ca`
- `./easyrsa build-server-full hub.stuff.ts.net`
- `./easyrsa build-server-full leaf1.stuff.ts.net`
- `./easyrsa build-server-full services.stuff.ts.net`
- `./easyrsa gen-crl`
- `./easyrsa gen-dh`

The `.gitignore` takes care of keeping secrets out of the git repo:

There are two directories under `easyrsa3/pki/`: `issued/` and `private/`. The former contains certificates and the latter contains keys:
- copy `ca.crt`, `crl.pem`, and `dh.pem` to `custom/`
- copy hub cert and key to `custom/server.crt` and `custom/server.key` (the server cert and key are named `hub.stuff.ts.net.crt` and `hub.stuff.ts.net.key` 
depending on the FQDN used to create the certificate. 

The default `include.conf` example already refers to `custom/server.crt` and `custom/server.key` for the `defaultssl` profile:

```
<sslprofile certfile="/etc/inspircd/custom/server.crt"
            keyfile="/etc/inspircd/custom/server.key"
            cafile="/etc/inspircd/custom/ca.crt"
            crlfile="/etc/inspircd/custom/crl.pem"
            dhfile="/etc/inspircd/custom/dh.pem"
            name="defaultssl"
            tlsv11="no"
            tlsv12="yes"
            tlsv13="yes"
            renegotiation="yes"
            requestclientcert="yes"
            provider="gnutls">
```

## Hub (continued)
create a `custom/links.conf`. The following describes a declaration for a leaf configuration:

```
<link allowmask="*"
      bind="100.79.209.72"
      hidden="no"
      sslprofile="defaultssl"
      ipaddr="100.83.238.47"
      name="lux.supernets.org"
      port="&env.SERVER_SSL_PORT;"
      recvpass="&env.LINK_RECV_PASSWORD;"
      sendpass="&env.LINK_SEND_PASSWORD;"
      statshidden="no"
      timeout="&env.LINK_TIMEOUT;">
```
- `chown -R 999 custom/`
- `docker-compose build`
- `docker-compose up -d`

## Leaf servers
- copy `config.env.example` to `config.env` and edit
- copy `include.conf.example` to `custom/include.conf` and edit (don't delete) as much as possible for now

### Internal TLS
- Copy certificate and key as well as `ca.crt` and `dh.pem` from the `easyrsa3` CA (probably located on the hub server) to
the leaf server (these files go in `custom/` and should also be named `server.crt` and `server.key`.)

### External TLS
- Copy your issued certificate and key to `custom/irc.crt` and `custom/irc.key` respectively
- Add the following to `custom/include.conf`: 

```
<sslprofile certfile="/etc/inspircd/custom/irc.crt"
            keyfile="/etc/inspircd/custom/irc.key"
            cafile="/etc/inspircd/custom/irc.ca.crt"
            name="supernets_ssl"
            tlsv11="no"
            tlsv12="yes"
            tlsv13="yes"
            renegotiation="yes"
            requestclientcert="yes"
            provider="gnutls">
```

and also change the bind for `6697` to use the `supernets_ssl` SSL profile: 

```
<bind address="*"
      port="&env.SSL_PORT;"
      sslprofile="supernets_ssl"
      type="clients">
```

### Tor hidden service 
Tor can be configured with HAProxy between inspircd and Tor to identify clients based on their circuit ID; therefore a ULA-based IPv6
hostmask can be assigned to help identify each unique client: 

- cd to `tor/`
- `docker-compose up -d` 
- To get the hidden service hostname: 

```
docker exec -it tor-tor-1 cat /var/lib/tor/ircd/hostname
q6ihxyqviqz76xt6dcpvgidbal64ltbvptbjp4yoxyjihgmqpxugcbid.onion
```

HAProxy is necessary in this case because Tor's `HiddenServiceExportCircuitID` uses PROXY protocol v1 and inspircd uses PROXY protocol v2, HAProxy supports both: 

```
frontend tor-north
  bind                 127.0.0.1:19818 accept-proxy
  mode                 tcp
  default_backend      inspircd-south

backend inspircd-south
  mode   tcp
  server inspircd 127.0.0.1:7001 send-proxy-v2
```

- cd to `haproxy/`
- `docker-compose up -d`
- By default, the inspircd `include.conf` should already provide the necessary configuration:

```
<bind address="127.0.0.1"
      port="7001"
      hook="haproxy">

<exception host="*@fc00:dead:beef:4dad::/64"
           reason="Tor ULA addresses (represents circuit ID)">

<connect commandrate="&env.COMMAND_RATE;"
         fakelag="&env.FAKE_LAG;"
         allow="127.0.0.1/32"
         hardsendq="&env.HARD_SENDQ;"
         maxchans="&env.MAX_CHANS;"
         pingfreq="&env.PING_FREQ;"
         recvq="&env.RECVQ;"
         softsendq="&env.SOFT_SENDQ;"
         threshold="&env.COMMAND_RATE_THRESHOLD;"
         timeout="&env.PARTIAL_CONNECT_TIMEOUT;"
         usecloak="yes"
         useconnflood="&env.USE_CONN_FLOOD;"
         usednsbl="no"
         useident="no"
         resolvehostnames="no"
         useconnectban="no"
         globalmax="&env.GLOBAL_MAX;"
         localmax="&env.LOCAL_MAX;"
         maxconnwarn="&env.MAX_CONN_WARN;"
         modes="&env.DEFAULT_USER_MODES;"
         name="tor_haproxy_shim"
         port="7001">

<connect commandrate="&env.COMMAND_RATE;"
         fakelag="&env.FAKE_LAG;"
         allow="fc00:dead:beef:4dad::/64"
         hardsendq="&env.HARD_SENDQ;"
         maxchans="&env.MAX_CHANS;"
         pingfreq="&env.PING_FREQ;"
         recvq="&env.RECVQ;"
         softsendq="&env.SOFT_SENDQ;"
         threshold="&env.COMMAND_RATE_THRESHOLD;"
         timeout="&env.PARTIAL_CONNECT_TIMEOUT;"
         usecloak="yes"
         useconnflood="&env.USE_CONN_FLOOD;"
         usednsbl="no"
         useident="no"
         resolvehostnames="no"
         useconnectban="no"
         autojoin="#tor"
         globalmax="&env.GLOBAL_MAX;"
         localmax="&env.LOCAL_MAX;"
         maxconnwarn="&env.MAX_CONN_WARN;"
         modes="&env.DEFAULT_USER_MODES;"
         name="tor"
         port="6668">
``` 

This unfortunately requires two connect blocks due to how HAProxy support works on inspircd4 (this seems to work differently from inspircd3.)

There is no TLS for Tor connectivity because Tor hidden services are already encrypted. There are no authorities which issue certificates 
for `.onion` domains either. There is no reason to use TLS with a Tor hidden service. To connect to the service: 

#### Onionbalance v3 
- This is not configured, but I will consider adding it to the Tor configuration if its of interest: https://onionservices.torproject.org/apps/base/onionbalance/v3/tutorial/
`HiddenServiceOnionbalanceInstance` would essentially allow multiple leaf servers to provide Tor access using the same `MasterOnionAddress`
but requires a shared secret between leaf server Tor instances.

```
proxychains4 irssi 
/connect q6ihxyqviqz76xt6dcpvgidbal64ltbvptbjp4yoxyjihgmqpxugcbid.onion 6668
```

## Atheme services
To configure Atheme, add the following to `custom/links.conf` on the hub server:

```
<link allowmask="*"
      bind="127.0.0.1"
      hidden="no"
      name="services.supernets.org"
      recvpass="&env.LINK_RECV_PASSWORD;"
      sendpass="&env.LINK_SEND_PASSWORD;"
      statshidden="no"
      timeout="&env.LINK_TIMEOUT;">
```

Atheme also requires the following to be added to `custom/include.conf`:

```
<bind address="127.0.0.1"
      port="6000"
      type="servers">
```

Note that it does not specify TLS in this case, that's provided with `stunnel`:

- cd into the `stunnel/` directory
- edit `stunnel.conf`
- `docker-compose build`
- `docker-compose up -d`
- Refer to https://github.com/supernets/atheme/tree/master for Atheme configuration instructions.
