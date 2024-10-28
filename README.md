# Instructions 

## docker-compose 
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
- On `hub.netcrave.network` add something like this to the `include.conf`:

```
<autoconnect period="8s"
             server="leaf.netcrave.network">

<link allowmask="*"
      bind="*"
      hidden="no"
      sslprofile="defaultssl"
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
      ipaddr="*"
      name="hub.netcrave.network"
      port="&env.SERVER_SSL_PORT;"
      recvpass="&env.LINK_RECV_PASSWORD;"
      sendpass="&env.LINK_SEND_PASSWORD;"
      statshidden="no"
      timeout="&env.LINK_TIMEOUT;">
```
