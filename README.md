# Instructions 

## docker-compose 
- if you run into problems. delete stale containers and: `docker rmi inspi4` and `docker volume prune` to make sure there are no stale images and volumes.
- copy `config.env.exmaple` to `config.env` and edit 
- optional: if you intend to link, copy `include.default.conf` to `include.conf` and edit
- build: `docker-compose -f docker-compose.yml build` use: `docker-compose.linked.yml` if you intend to link.
- start: `docker-compose -f docker-compose.yml up -d` also use the linked variant if you intend to link.

- ~~`docker build -t inspi4 -t inspi4:latest .`~~
- ~~`docker run -it --rm -e 'DEFAULT_BLOCK_HOST_MASK="nothing"' -net host inspi4`~~

# Optional 
- ~~create a custom `links.conf`~~
- ~~`docker run -it --rm -e 'DEFAULT_BLOCK_HOST_MASK="nothing"' -net host -v $(pwd)/links.conf:/etc/inspircd/links.conf:ro inspi4`~~

# Linking 
- Run `docker exec -it irc_ircd_linked_1 openssl x509 -fingerprint -in /etc/ssl/inspircd/server.crt` to get the fingerprints

- On `hub.netcrave.network` add something like this to the `include.conf`:

```
<autoconnect period="8s"
             server="leaf.netcrave.network">

<link allowmask="*"
      bind="*"
      hidden="no"
      sslprofile="defaultssl"
      fingerprint="64:00:B8:EB:82:79:68:49:27:FF:9F:C1:94:91:58:E3:DA:19:05:87"
      ipaddr="*"
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
      bind="*"
      hidden="no"
      sslprofile="defaultssl"
      fingerprint="78:50:91:AD:3E:85:19:49:1C:F9:FF:72:94:86:97:28:BE:8B:00:46""
      ipaddr="*"
      name="hub.netcrave.network"
      port="&env.SERVER_SSL_PORT;"
      recvpass="&env.LINK_RECV_PASSWORD;"
      sendpass="&env.LINK_SEND_PASSWORD;"
      statshidden="no"
      timeout="&env.LINK_TIMEOUT;">
```
