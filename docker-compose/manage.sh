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
  --help)
    echo "
NAME:
OMniLeads docker-compose cmd tool

USAGE:
./manage.sh COMMAND

  --reset_pass: reset admin password to admin admin
  --init_env: init some basic configs in order to test it
  --delete_pgsql: delete all PostgreSQL databases
  --delete_redis: delete cache
"
    shift
    exit 1
    ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
    ;;
esac
