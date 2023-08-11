#!/bin/bash

echo "$(date): transition to master, exec oml_cluster_transition.sh" >> /var/log/keepalive_transition.log

systemctl restart asterisk
#sleep 3
#/usr/bin/podman exec -it oml-asterisk-server python3 /opt/asterisk/scripts/asterisk_transition.py
sleep 30
/usr/local/bin/oml_manage --regenerar_asterisk