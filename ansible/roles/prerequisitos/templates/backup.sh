#!/bin/bash

set -x

source /etc/default/backup.env
/usr/bin/podman run --name pgsql_bk_$(date +"%Y%m%d_%H%M") --network=host --env-file /etc/default/backup.env -e BACKUP_FILENAME=pgsql-backup-$(date +"%Y%m%d_%H%M").sql --rm {{ omnileads_img }} bash -x /opt/omnileads/bin/init_pgsql_backup.sh

