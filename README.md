# Instructions 

## docker-compose 
- if you are not starting from scratch. delete stale containers and: `docker rmi inspi4` and `docker volume rm inspi4_ssl` 
- copy `config.env.exmaple` to `config.env` and edit 
- optional: if you intend to link, copy `include.default.conf` to `include.conf` and edit (see linking section below.)
- start: `docker-compose -f docker-compose.standalone.yml up -d` also use the linked variant if you intend to link.

- ~~`docker build -t inspi4 -t inspi4:latest .`~~
- ~~`docker run -it --rm -e 'DEFAULT_BLOCK_HOST_MASK="nothing"' -net host inspi4`~~

# Optional 
- ~~create a custom `links.conf`~~
- ~~`docker run -it --rm -e 'DEFAULT_BLOCK_HOST_MASK="nothing"' -net host -v $(pwd)/links.conf:/etc/inspircd/links.conf:ro inspi4`~~

# Linking 
- Run `docker exec -it ircd_ircd_linked_1 openssl x509 -sha256 -fingerprint -in /etc/ssl/inspircd/server.crt  | tr -d ":" | tr '[:upper:]' '[:lower:]'` 
to get the SSL fingerprints, the `fingerprint` refers to the remote SSL certificate fingerprint for each linking section.

- On `hub.netcrave.network` add something like this to the `include.conf`:

```
<autoconnect period="8s"
             server="leaf.netcrave.network">

<link allowmask="*"
      bind="1.2.3.4"
      hidden="no"
      sslprofile="defaultssl"
      fingerprint="c543d8a4a6c825d917d20520e4962e4bcdc3c3c5d856815f7fd626b708842baf"
      ipaddr="4.2.3.1"
      name="leaf.netcrave.network"
      port="&env.SERVER_SSL_PORT;"
      recvpass="&env.LINK_RECV_PASSWORD;"
      sendpass="&env.LINK_SEND_PASSWORD;"
      statshidden="no"
      timeout="&env.LINK_TIMEOUT;">
```
- On `leaf.netcrave.network` add something like this to the `include.conf`:

```
<autoconnect period="8s"
             server="hub.netcrave.network">

<link allowmask="*"
      bind="4.2.3.1"
      hidden="no"
      sslprofile="defaultssl"
      fingerprint="09afef0d8561b8d13e3e7a480ed006caed11d3f5b36c5f4569c60060baa936cd"
      ipaddr="1.2.3.4"
      name="hub.netcrave.network"
      port="&env.SERVER_SSL_PORT;"
      recvpass="&env.LINK_RECV_PASSWORD;"
      sendpass="&env.LINK_SEND_PASSWORD;"
      statshidden="no"
      timeout="&env.LINK_TIMEOUT;">
```

# Linking with services
- Doesn't work yet: https://github.com/atheme/atheme/issues/904
```
<link allowmask="*"
      bind="127.0.0.1"
      hidden="no"
      ipaddr="127.0.0.1"
      name="services.netcrave.network"
      port="7001"
      recvpass="&env.LINK_RECV_PASSWORD;"
      sendpass="&env.LINK_SEND_PASSWORD;"
      statshidden="no"
      timeout="&env.LINK_TIMEOUT;">
```

# easyrsa
On the hub:
- `./easyrsa init-pki` 
- `./easyrsa build-ca`
- `./easyrsa build-server-full hub.stuff.ts.net`
- `./easyrsa gen-crl`
- `./easyrsa gen-dh`

The `.gitignore` takes care of keeping secrets out of the git repo:

- copy `ca.crt`, `crl.pem`, and `dh.pem` to `custom/`
- `chown -R 999 custom/`
- copy hub cert and key to `custom/server.crt` and `custom/server.key`
- manually copy certs and keys as well as `dh.pem` to each leaf. 
