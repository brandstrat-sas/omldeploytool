#!/bin/bash

case $1 in
  --reset_pass)
    echo "reset django admin password"
    docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
    ;;
  --init_env)
    docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
    ;;
  --regenerar_asterisk)
    docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py regenerar_asterisk
    ;;
  --clean_postgres_db)
    echo "echo drop all on PostgreSQL"
    docker stop oml-nginx
    docker stop oml-django
    docker stop oml-django-cron
    docker stop oml-asterisk
    docker stop oml-fastagi
    docker stop oml-postgres
    docker rm oml-postgres
    docker volume rm oml_postgresql_persistent
    docker-compose up -d 
    until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
    docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
    #docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
    ;;
  --clean_redis)
    echo "echo drop all on REDIS"
    docker stop oml-redis
    docker rm oml-redis
    docker volume rm oml_redis_persistent
    docker-compose up -d --force-recreate --no-deps redis
    ;;
  --clean_bucket)
    echo "echo drop all on MINIO"
    docker stop oml-minio
    docker rm oml-minio
    docker volume rm oml_minio_persistent
    docker-compose up -d --force-recreate --no-deps minio
    echo "waiting for MINIO raiseup"
    sleep 10
    mc alias set MINIO http://localhost:9000 minio s3minio123
    mc mb MINIO/omnileads
    mc admin user add MINIO devenv s3omnileads123
    mc admin policy set MINIO readwrite user=devenv
    ;;
  --clean_postgres_tables)
    echo "drop calls and agent count tables PostgreSQL"
    docker exec -it oml-django psql -c 'DELETE FROM queue_log'
    docker exec -it oml-django psql -c 'DELETE FROM reportes_app_llamadalog'
    docker exec -it oml-django psql -c 'DELETE FROM reportes_app_actividadagentelog'
    docker exec -it oml-django psql -c 'DELETE FROM ominicontacto_app_respuestaformulariogestion'
    docker exec -it oml-django psql -c 'DELETE FROM ominicontacto_app_auditoriacalificacion'
    docker exec -it oml-django psql -c 'DELETE FROM ominicontacto_app_calificacioncliente'
    ;;
  --show_bucket)
    mc alias set MINIO http://localhost:9000 minio s3minio123
    mc ls --recursive MINIO/omnileads
    ;;
  --generate_call)
    echo "generate an ibound call through PSTN-Emulator container"
    docker exec -it oml-pstn-emulator sipp -sn uac 127.0.0.1:5060 -s stress -m 1 -r 1 -d 60000 -l 1
    ;;
  --asterisk_cli)
    docker exec -it oml-asterisk asterisk -rvvvv
    ;;
  --asterisk_bash)
    docker exec -it oml-asterisk bash
    ;;
  --asterisk_logs)
    docker logs -f oml-asterisk
    ;;
  --kamailio_logs)
    docker logs -f oml-kamailio
    ;;
  --django_logs)
    docker logs -f oml-django
    ;;
  --django_bash)
    docker exec -it oml-django bash
    ;;  
  --django_shell)
    docker exec -it oml-django python3 manage.py shell
    ;;    
  --fastagi_bash)
    docker exec -it oml-fastagi bash
    ;;      
  --fastagi_logs)
    docker logs -f oml-fastagi
    ;;
  --rtpengine_logs)
    docker logs -f oml-rtpengine
    ;;
  --rtpengine_bash)
    docker exec -it oml-rtpengine bash
    ;;  
  --websockets_logs)
    docker logs -f oml-websockets
    ;;
  --rtpengine_conf)
    docker exec -it oml-rtpengine cat /etc/rtpengine.conf
    ;;
  --pgsql_shell)
    docker exec -it oml-django psql
    ;;    
  --nginx_t)
    docker exec -it oml-nginx nginx -T
    ;;
  --help)
    echo "
NAME:
OMniLeads docker-compose cmd tool

USAGE:
./manage.sh COMMAND

--reset_pass: reset admin password to admin admin
--init_env: init some basic configs in order to test it
--regenerar_asterisk: populate asterisk / redis config
--clean_postgres_db: delete all PostgreSQL databases
--clean_redis: delete cache
--asterisk_CLI: launch asterisk CLI
--asterisk_terminal: launch asterisk container bash shell
--asterisk_logs: show asterisk container logs
--kamailio_logs: show container logs
--django_logs: show container logs
--rtpengine_logs: show container logs
--websockets_logs: show container logs
--nginx_t: print nginx container run config
--generate_call: generate an ibound call through PSTN-Emulator container
--clean_postgres_tables: drop calls and agent count tables PostgreSQL
"
    shift
    exit 1
    ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
    ;;
esac
