#!/bin/bash

echo "$(date): transition to master" >> /var/log/keepalive_transition.log

/usr/bin/podman exec -it oml-asterisk-server asterisk -rx 'pjsip reload'
sleep 3
/usr/bin/podman exec -it oml-asterisk-server python3 /opt/asterisk/virtualenv/scripts/asterisk_transition.py
sleep 3
/usr/local/bin/oml_manage --regenerar_asterisk