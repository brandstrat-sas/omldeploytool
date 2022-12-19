#!/bin/bash

case $1 in
  --reset_pass)
    echo "reset django admin password"
    docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
    ;;
  --init_env)
    docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
    ;;
  --delete_pgsql)
    echo "echo drop all on PostgreSQL"
    docker stop oml-postgres
    docker rm oml-postgres
    sleep 2
    docker volume rm prodenv_postgresql_data
    docker-compose up -d --force-recreate --no-deps postgresql
    ;;
  --delete_redis)
    echo "echo drop all on REDIS"
    docker stop oml-redis
    docker rm oml-redis
    docker volume rm prodenv_redis_data
    docker-compose up -d --force-recreate --no-deps redis
    ;;
  --generate_call)
    docker exec -it oml-pstn-emulator sipp -sn uac 127.0.0.1:6060 -s stress -m 1 -r 1 -d 60000 -l 1
    ;;
  --delete_pgsql_tables)
    docker exec -it oml-django psql -c 'DELETE FROM queue_log'
    docker exec -it oml-django psql -c 'DELETE FROM reportes_app_llamadalog'
    docker exec -it oml-django psql -c 'DELETE FROM reportes_app_actividadagentelog'
    docker exec -it oml-django psql -c 'DELETE FROM ominicontacto_app_respuestaformulariogestion'
    docker exec -it oml-django psql -c 'DELETE FROM ominicontacto_app_auditoriacalificacion'
    docker exec -it oml-django psql -c 'DELETE FROM ominicontacto_app_calificacioncliente'
    ;;
  --help)
    echo "
NAME:
OMniLeads docker-compose cmd tool

USAGE:
./manage.sh ARG

  --reset_pass: reset admin password to admin admin
  --init_env: init some basic configs in order to test it
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
