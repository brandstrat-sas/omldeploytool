#!/bin/bash

echo "$(date): transition to master" >> /var/log/keepalive_transition.log

/usr/bin/podman exec -it oml-asterisk-server asterisk -rx 'module reload'
sleep 1
/usr/bin/podman exec -it oml-asterisk-server asterisk -rx 'module reload res_odbc.so'
sleep 1
/usr/bin/podman exec -it oml-asterisk-server asterisk -rx 'pjsip reload'
sleep 1
/usr/bin/podman exec -it oml-asterisk-server python3 /opt/asterisk/virtualenv/scripts/asterisk_transition.py

