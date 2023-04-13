#!/bin/bash

echo "Remote host address:"
read REMOTE

SERVICE="[Unit]
Description=Alef Union Reverse Proxy

[Service]
ExecStart=reverseproxy
WorkingDirectory=/srv
LimitNOFILE=4096
Restart=always
User=www

[Install]
WantedBy=multi-user.target
"

# Upload binary
GOOS=linux go build -o reverseproxy
scp reverseproxy root@$REMOTE:/usr/local/sbin
rm reverseproxy

# Create service
ssh root@$REMOTE "
id -u www &>/dev/null || useradd www;\
chown www:www /usr/local/sbin/reverseproxy;\
setcap cap_net_bind_service=ep /usr/local/sbin/reverseproxy;\
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
