# Getting started 
This docker configuration relies on the host network driver meaning it doesn't setup any internal networks or even a separate NetNS. Your 
mileage may vary if you change the intended network driver for Docker. There are a few caveats to how this is designed: 

- Some configuration is managed through `config.env` and exported to the Docker container as environment variables; This can help with convergence of configuration 
  between hosts but results in a configuration that cannot be changed with a simple `/quote REHASH`.
- inspircd autoloads any `.conf` file from the `custom/` directory (it's mapped into the container from the `docker-compose.yml` file.
- Environment variables are referenced in the configuration files using `&env.ENV_VAR_NAME;` and this usage can be found throughout the configuration.  
- Changing the `config.env` means that the container must be re-created: `docker-compose up -d`

When editing configuration, use generated passwords everywhere possible: 

```
echo $(dd if=/dev/urandom bs=1024 count=1 status=none | sha256sum | base64 | head -c 64
```

Some passwords need to be consistent (uplink send/recv passwords for example) across servers. A subject for improvement would be not using the environment
for unencrypted passwords, see [#TODO](#TODO) section for more info on how this can be improved. 

## Hub
- copy `config.env.example` to `config.env` and edit 
- copy `include.conf.example` to `custom/include.conf` and edit (don't delete) as much as possible for now

### Internal TLS
The following steps describe how to setup `easyrsa3` for internal TLS. This step is necessary regardless of whether you intended to use
issued certificates for leaf servers because it provides TLS encryption between the hub and it's leaf servers and between services. Refer
to the [#external-tls](#external-tls) section under [#leaf-servers](#leaf-servers) for more info. To bootstrap internal TLS with an `easyrsa3` 
CA perform the following:

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

### Uplink (to hub)
Currently, this is setup for the hub to uplink to leaf servers, but the opposite can be provided with a `<link>` block in the
`include.conf`.

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

and also change the bind for `6697` to use the `supernets_ssl` profile: 

```
<bind address="*"
      port="&env.SSL_PORT;"
      sslprofile="supernets_ssl"
      type="clients">
```

### Tor hidden service
If you don't want Tor, skip to [#leaf-servers-continued](#leaf-servers-continued)

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

#### Onionbalance v3 
- This is not configured, but I will consider adding it to the Tor configuration if its of interest: https://onionservices.torproject.org/apps/base/onionbalance/v3/tutorial/
`HiddenServiceOnionbalanceInstance` would essentially allow multiple leaf servers to provide Tor access using the same `MasterOnionAddress`
but requires a shared secret between leaf server Tor instances.

There is no TLS for Tor connectivity because Tor hidden services are already encrypted end-to-end. To connect to the hidden service: 

```
proxychains4 irssi 
/connect q6ihxyqviqz76xt6dcpvgidbal64ltbvptbjp4yoxyjihgmqpxugcbid.onion 6668
```

After connecting the user will have an address that is unique to the circuit ID that is in use:

```
1:08 -!- sq_ [~stelleri@4m4l237j:f6jtvjrf:n6du6chj:hidden]
11:08 -!-  ircname  : User irc
11:08 -!-  hostname : ~irc@fc00:dead:beef:4dad::5e fc00:dead:beef:4dad::5e
11:08 -!-  channels : #tor
11:08 -!-  server   : miami.supernets.org [internet relay chat network]
11:08 -!-  modes    : +ix
11:08 -!-           : * is connecting from an unknown autonomous system
11:08 -!-           : * is connecting from an unknown country
11:08 -!-  idle     : 0 days 0 hours 46 mins 44 secs [signon: Sun Jan  5 17:22:28 2025]
11:08 -!- End of WHOIS
```

## Leaf servers (continued) 
- chown -R 999 custom/
- docker-compose build
- docker-compose up -d

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

# Administration 
- OPER: `/oper admin <password@config.env>`
- OJOIN Override any channel restriction to join: `/quote ojoin #services`
- SNOMASKS are configured to log to `#opers`

## Debugging 
- To start inspircd with debugging, add `-d` to `DAEMON_FLAGS` in `config.env`
- `docker-compose up -d`
- `docker logs -f inspircd-ircd-1`

# TODO
- The `password_hash` in conjunction with the `PBKDF` module can be used to produce hashed passwords which can be used in configuration: https://docs.inspircd.org/3/modules/password_hash/ this unfortunately as it is now assumes that you already have a server running and can use `/MKPASSWD` to create passwords.

- Using `docker-compose up --no-start` will create the container but not start it. This is useful if prior to starting the container more configuration needs
  needs to be completed, it maps all of the volumes / files needed, etc. This also allows you to use `docker-compose run` on the created container, but won't
  start the container; for running one-off commands that are not pertinent to the container's primary purpose. If inspircd provided some functionality like
  creating password hashes or generating certificates from the inspircd executable this would be really useful.
  
