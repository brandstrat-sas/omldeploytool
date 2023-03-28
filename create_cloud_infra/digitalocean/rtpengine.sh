#!/bin/bash

omni_ip_wan=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
omni_ip_lan=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

apt update && apt install -y podman

cat >> /etc/default/rtpengine.env <<EOF
# Add extra options here
WAN_IP=$omni_ip_wan
LAN_IP=$omni_ip_lan
ENV=cloud

EOF

cat >> /etc/systemd/system/rtpengine.service <<EOF
[Unit]
Description=Podman container-oml-rtpengine-server.service
Documentation=man:podman-generate-systemd(1)
Wants=network-online.target
After=network-online.target
RequiresMountsFor=%t/containers

[Service]
Environment=PODMAN_SYSTEMD_UNIT=%n
Restart=on-failure
TimeoutStopSec=70
ExecStartPre=/bin/rm -f %t/%n.ctr-id
ExecStart=/usr/bin/podman run --cidfile=%t/%n.ctr-id --cgroups=no-conmon --sdnotify=conmon --replace --detach --network=host --name=oml-rtpengine-server --env-file=/etc/default/rtpengine.env --rm  docker.io/omnileads/rtpengine:230204.01 
ExecStop=/usr/bin/podman stop --ignore --cidfile=%t/%n.ctr-id
ExecStopPost=/usr/bin/podman rm -f --ignore --cidfile=%t/%n.ctr-id
Type=notify
NotifyAccess=all

[Install]
WantedBy=default.target

EOF

systemctl enable rtpengine
systemctl start rtpengine