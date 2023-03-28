#!/bin/bash

case $1 in
  --reset_pass)
    echo "reset django admin password"
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
    ;;
  --init_env)
    echo "init Environment with some data"
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
    ;;
  --regenerar_asterisk)
    echo "regenerate redis asterisk data"
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py regenerar_asterisk
    ;;
  --clean_redis)
    echo "drop all on REDIS"
    systemctl stop oml-redis-server
    sleep 2
    podman rm oml-redis-server
    podman volume rm oml_redis
    sleep 2
    systemctl start oml-redis-server
    sleep 5
    podman exec -it oml-django-server python3 /opt/omnileads/ominicontacto/manage.py regenerar_asterisk
    ;;
  --generate_call)
    echo "generate an ibound call through PSTN-Emulator container"
    podman exec -it oml-pstn-server sipp -sn uac 127.0.0.1:5060 -s stress -m 1 -r 1 -d 60000 -l 1
    ;;
  --show_bucket)
    podman exec -it oml-django-server aws --endpoint-url ${S3_ENDPOINT} s3 ls --recursive s3://${S3_BUCKET_NAME}
    ;;
  --asterisk_cli)
    podman exec -it oml-asterisk-server asterisk -rvvvv
    ;;
  --psql)
    podman exec -it oml-django-server psql
    ;;
  --redis_cli)
    podman run -it --name oml-redis-cli docker.io/redis redis-cli -h $(cat /etc/default/django.env |grep REDIS | awk -F= '{print $2}')
    ;;
  --asterisk_terminal)
    podman exec -it oml-asterisk-server bash
    ;;
  --asterisk_logs)
    podman logs -f oml-asterisk-server
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
  --ws_logs)
    podman logs -f oml-websockets-server
    ;;
  --redis_logs)
    podman logs -f oml-redis-server
    ;;
  --sentinel_logs)
    podman logs -f oml-sentinel-server
    ;;
  --haproxy_logs)
    podman logs -f oml-haproxy-server
    ;;
  --nginx_logs)
    podman logs -f oml-nginx-server
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

  --reset_pass: reset admin password to admin admin (you should run on app_host)
  --init_env: init some basic configs in order to test it (you should run on app_host)
  --regenerar_asterisk: populate asterisk / redis config  (you should run on app_host)
  --clean_redis: clean cache (you should run on data_host)
  --asterisk_cli: launch asterisk CLI  (you should run on voice_host)
  --redis_cli: launch redis CLI (you should run on app_host)
  --psql: launch psql CLI (you should run on app_host) 
  --asterisk_terminal: launch asterisk container bash shell (you should run on voice_host)
  --asterisk_logs: show asterisk container logs (you should run on voice_host)
  --kamailio_logs: show container logs (you should run on app_host)
  --django_logs: show container logs (you should run on app_host)
  --rtpengine_logs: show container logs (you should run on voice_host)
  --websockets_logs: show container logs (you should run on app_host)
  --nginx_t: print nginx container run config (you should run on app_host)
  --generate_call: generate an ibound call from PSTN-Emulator container to OMniLeads ACD (you should run on app_host)
"
    shift
    exit 1
    ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
    ;;
esac
