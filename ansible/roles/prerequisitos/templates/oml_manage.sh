#!/bin/bash

case $1 in
  --reset_pass)
    echo "reset django admin password"
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
    ;;
  --init_env)
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
    ;;
  --delete_pgsql)
    echo "drop all on PostgreSQL"
    systemctl stop oml-postgresql-server
    sleep 2
    podman rm oml-postgresql-server
    podman volume rm oml_postgres
    sleep 2
    systemctl start oml-postgresql-server
    ;;
  --delete_redis)
    echo "drop all on REDIS"
    systemctl stop oml-redis-server
    sleep 2
    podman rm oml-redis-server
    podman volume rm oml_redis
    sleep 2
    systemctl start oml-redis-server
    ;;
  --asterisk_cli)
    podman exec -it oml-asterisk-server asterisk -rvvvv
    ;;
  --asterisk_bash)
    podman exec -it oml-asterisk-server bash
    ;;
  --asterisk_logs)
    podman exec -it oml-asterisk-server bash
    ;;
  --kamailio_logs)
    podman logs -f oml-kamailio-server
    ;;
  --django_logs)
    podman logs -f oml-django-server
    ;;
  --rtpengine_logs)
    podman logs -f oml-rtpengine-server
    ;;
  --websockets_logs)
    podman logs -f oml-websockets-server
    ;;
  --rtpengine_conf)
    podman exec -it oml-rtpengine-server cat /etc/rtpengine.conf
    ;;
  --nginx_t)
    podman exec -it oml-nginx-server nginx -T
    ;;
  --help)
    echo "
NAME:
OMniLeads cmd tool

USAGE:
./manage.sh COMMAND

  -- reset_pass: reset admin password to admin admin
  -- init_env: init some basic configs in order to test it
  -- delete_pgsql: delete all PostgreSQL databases
  -- delete_redis: delete cache
"
    shift
    exit 1
    ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
    ;;
esac
