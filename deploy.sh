#!/bin/bash

echo "Remote host address:"
read REMOTE

SERVICE="[Unit]
Description=Alef Union Reverse Proxy

[Service]
ExecStart=reverseproxy
WorkingDirectory=/srv
User=www
Restart=always
AmbientCapabilities=CAP_NET_BIND_SERVICE
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
"

# Upload binary
GOOS=linux go build -o reverseproxy
ssh root@$REMOTE "systemctl stop reverseproxy &>/dev/null"
scp reverseproxy root@$REMOTE:/usr/local/sbin
rm reverseproxy

# Create service
ssh root@$REMOTE "
id -u www &>/dev/null || useradd www;\
chown www:www /usr/local/sbin/reverseproxy;\
install -d -m 0755 /etc/reverseproxy;\
touch /etc/reverseproxy/hostmap;\
chmod 755 /etc/reverseproxy/hostmap;\
echo \"$SERVICE\" > /etc/systemd/system/reverseproxy.service;\
systemctl daemon-reload;\
systemctl enable reverseproxy;\
"

# Edit hostmap
ssh root@$REMOTE -t "vi /etc/reverseproxy/hostmap"

# Start service
ssh root@$REMOTE "systemctl start reverseproxy"
