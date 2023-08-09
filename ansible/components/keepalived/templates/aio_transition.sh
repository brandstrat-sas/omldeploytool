#!/bin/bash

echo "$(date): transition to master, exec oml_cluster_transition.sh" >> /var/log/keepalive_transition.log

/usr/bin/podman exec -it oml-asterisk-server asterisk -rx 'pjsip reload'
/usr/bin/podman exec -it oml-asterisk-server asterisk -rx 'manager reload'
sleep 3
/usr/bin/podman exec -it oml-asterisk-server python3 /opt/asterisk/virtualenv/scripts/asterisk_transition.py
sleep 3
/usr/local/bin/oml_manage --regenerar_asterisk