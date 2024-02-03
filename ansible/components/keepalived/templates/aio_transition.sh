#!/bin/bash

echo "$(date): transition to master, exec oml_cluster_transition.sh" >> /var/log/keepalive_transition.log

/usr/local/bin/oml_manage --regenerar_asterisk
sleep 10
systemctl restart asterisk