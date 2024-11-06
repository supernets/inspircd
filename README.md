# Instructions 

## docker-compose 
1. copy `config.env.exmaple` to `config.env` and edit 
2. copy `include.conf.example` to `custom/include.conf`
3. follow steps from [#easyrsa] section
4. `docker-compose build`
5. `docker-compose up -d`

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
