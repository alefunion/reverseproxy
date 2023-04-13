# Alef Union Reverse Proxy

## Install

### Locally

```sh
GOOS=linux go build

scp reverseproxy root@x.servers.alefunion.com:/usr/bin
```

### On server

On server:

```sh
sudo useradd www
sudo chown www:www /usr/bin/reverseproxy
sudo setcap cap_net_bind_service=ep /usr/bin/reverseproxy

sudo install -d -m 0744 /etc/reverseproxy
sudo vi /etc/reverseproxy/hostmap
# Write host map:
#	alefunion.com     localhost:8000
#	api.alefunion.com localhost:8001
```
