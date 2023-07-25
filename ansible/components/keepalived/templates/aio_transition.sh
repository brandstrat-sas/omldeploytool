#!/bin/bash

echo "$(date): transition to master" >> /var/log/keepalive_transition.log

oml_manage --regenerar_asterisk
sleep 2
/usr/bin/podman exec -it oml-asterisk-server asterisk -rx 'pjsip reload'
sleep 2
/usr/bin/podman exec -it oml-asterisk-server python3 /opt/asterisk/virtualenv/scripts/asterisk_transition.py

