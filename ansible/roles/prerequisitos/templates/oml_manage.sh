#!/bin/bash

case $1 in
  --reset_pass)
    echo "reset django admin password"
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
    ;;
  --init_env)
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
    ;;
  --regenerar_asterisk)
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py regenerar_asterisk
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
  --generate_call)
    echo "generate an ibound call through PSTN-Emulator container"
    podman exec -it oml-pstn-emulator sipp -sn uac 127.0.0.1:6060 -s stress -m 1 -r 1 -d 60000 -l 1
    ;;
  --delete_pgsql_tables)
    echo "drop calls and agent count tables PostgreSQL"
    podman exec-it oml-django-server psql -c 'DELETE FROM queue_log'
    podman exec-it oml-django-server psql -c 'DELETE FROM reportes_app_llamadalog'
    podman exec-it oml-django-server psql -c 'DELETE FROM reportes_app_actividadagentelog'
    podman exec-it oml-django-server psql -c 'DELETE FROM ominicontacto_app_respuestaformulariogestion'
    podman exec-it oml-django-server psql -c 'DELETE FROM ominicontacto_app_auditoriacalificacion'
    podman exec-it oml-django-server psql -c 'DELETE FROM ominicontacto_app_calificacioncliente'
    ;;
  --asterisk_CLI)
    podman exec -it oml-asterisk-server asterisk -rvvvv
    ;;
  --asterisk_terminal)
    podman exec -it oml-asterisk-server bash
    ;;
  --asterisk_logs)
    podman logs -f oml-asterisk-server bash
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

  --reset_pass: reset admin password to admin admin
  --init_env: init some basic configs in order to test it
  --regenerar_asterisk: populate asterisk / redis config
  --delete_pgsql: delete all PostgreSQL databases
  --delete_redis: delete cache
  --asterisk_CLI: launch asterisk CLI
  --asterisk_terminal: launch asterisk container bash shell
  --asterisk_logs: show asterisk container logs
  --kamailio_logs: show container logs
  --django_logs: show container logs
  --rtpengine_logs: show container logs
  --websockets_logs: show container logs
  --nginx_t: print nginx container run config
  --generate_call: generate an ibound call through PSTN-Emulator container
  --delete_pgsql_tables: drop calls and agent count tables PostgreSQL
"
    shift
    exit 1
    ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
    ;;
esac
