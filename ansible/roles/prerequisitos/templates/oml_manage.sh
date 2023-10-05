#!/bin/bash


case $1 in

{% if container_orchest == "docker_compose" %}
  --reset_pass)
    echo "reset django admin password"
    docker exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
    ;;
  --init_env)
    echo "init Environment with some data"
    docker exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
    ;;
--regenerar_asterisk)
    echo "regenerate redis asterisk data"
    docker exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py regenerar_asterisk
    ;;
  --clean_redis)
    echo "drop all on REDIS"
    systemctl stop oml-redis-server
    sleep 2
    docker rm oml-redis-server
    docker volume rm oml_redis
    sleep 2
    systemctl start oml-redis-server
    sleep 5
    docker exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py regenerar_asterisk
    ;;
  --generate_call)
    echo "generate an ibound call through PSTN-Emulator container"
    docker exec -it oml-pstn-server sipp -sn uac 127.0.0.1:5060 -s stress -m 1 -r 1 -d 60000 -l 1
    ;;
  --show_bucket)
    docker exec -it oml-uwsgi-server aws --endpoint-url ${S3_ENDPOINT} s3 ls --recursive s3://${S3_BUCKET_NAME}
    ;;
  --asterisk_cli)
    docker exec -it oml-asterisk-server asterisk -rvvvv
    ;;
  --psql)
    docker exec -it oml-uwsgi-server psql
    ;;
  --redis_cli)
    docker run -it --name oml-redis-cli docker.io/redis redis-cli -h $(cat /etc/default/django.env |grep REDIS | awk -F= '{print $2}')
    ;;
  --asterisk_terminal)
    docker exec -it oml-asterisk-server bash
    ;;
  --asterisk_logs)
    docker logs -f oml-asterisk-server
    ;;
  --kamailio_logs)
    docker logs -f oml-kamailio-server
    ;;
  --django_bash)
    podman exec -it oml-uwsgi-server bash
    ;;  
  --django_shell)
    docker exec -it oml-uwsgi-server python3 manage.py shell
    ;;    
  --fastagi_bash)
    docker exec -it oml-fastagi-server bash
    ;;      
  --fastagi_logs)
    docker logs -f oml-fastagi-server
    ;;
  --rtpengine_logs)
    docker logs -f oml-rtpengine-server
    ;;
  --rtpengine_bash)
    docker exec -it oml-rtpengine-server bash
    ;;  
  --websockets_logs)
    docker logs -f oml-websockets-server
    ;;
  --rtpengine_conf)
    docker exec -it oml-rtpengine-server cat /etc/rtpengine.conf
    ;;
  --pgsql)
    docker exec -it oml-uwsgi-server psql
    ;;    
  --sentinel_logs)
    docker logs -f oml-sentinel-server
    ;;
  --haproxy_logs)
    docker logs -f oml-haproxy-server
    ;;
  --nginx_logs)
    docker logs -f oml-nginx-server
    ;;    
  --nginx_t)
    docker exec -it oml-nginx-server nginx -T
    ;;
{% else %}
  --reset_pass)
    echo "reset django admin password"
    podman exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
    ;;
  --init_env)
    echo "init Environment with some data"
    podman exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
    ;;
  --dialer_sync)
    echo "regenerate redis asterisk data"
    podman exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py sincronizar_wombat
    ;;  
  --redis_sync)
    echo "regenerate redis asterisk data"
    podman exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py regenerar_asterisk
    ;;
  --redis_clean)
    echo "¿Are you sure you want to delete all redis cache? yes or no"
    read confirmacion
    if [[ $confirmacion == "yes" ]]; then
      podman exec -it oml-redis-server redis-cli flushall
      podman exec -it oml-uwsgi-server python3 /opt/omnileads/ominicontacto/manage.py regenerar_asterisk
    else
      echo "Cancel action"
    fi    
    ;;
  --generate_call)
    echo "generate an ibound call through PSTN-Emulator container"
    podman exec -it oml-pstn-server sipp -sn uac 127.0.0.1:5060 -s stress -m 1 -r 1 -d 60000 -l 1
    ;;
  --show_bucket)
    podman exec -it oml-uwsgi-server aws --endpoint-url ${S3_ENDPOINT} s3 ls --recursive s3://${S3_BUCKET_NAME}
    ;;  
  --psql)
    podman exec -it oml-uwsgi-server psql
    ;;
  --redis_cli)
    podman run -it --name oml-redis-cli docker.io/redis redis-cli -h $(cat /etc/default/django.env |grep REDIS | awk -F= '{print $2}')
    ;;
  --asterisk_cli)
    podman exec -it oml-asterisk-server asterisk -rvvvv
    ;;
  --asterisk_bash)
    podman exec -it oml-asterisk-server bash
    ;;
  --asterisk_logs)
    podman logs -f oml-asterisk-server
    ;;
  --kamailio_logs)
    podman logs -f oml-kamailio-server
    ;;
  --django_logs)
    podman logs -f oml-uwsgi-server 
    ;;    
  --django_bash)
    podman exec -it oml-uwsgi-server bash
    ;;  
  --django_shell)
    podman exec -it oml-uwsgi-server python3 manage.py shell
    ;;    
  --django_commands)
    podman run --network=host --env-file /etc/default/django.env docker.io/omnileads:$2 /opt/omnileads/bin/django_commands.sh
    ;;      
  --fastagi_bash)
    podman exec -it oml-fastagi-server bash
    ;;      
  --fastagi_logs)
    podman logs -f oml-fastagi-server
    ;;
  --rtpengine_logs)
    podman logs -f oml-rtpengine-server
    ;;
  --rtpengine_bash)
    podman exec -it oml-rtpengine-server bash
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
{% endif %}    
  --help)
    echo "

NAME:
OMniLeads cmd tool

USAGE:
./manage.sh COMMAND

  --reset_pass: reset admin password to admin admin 
  --init_env: init some basic configs in order to test it
  --redis_sync: populate django config redis
  --redis_clean: clean cache  
  --redis_cli: launch redis CLI 
  --psql: launch psql CLI 
  --asterisk_cli: launch asterisk CLI 
  --asterisk_bash: launch asterisk container bash shell 
  --asterisk_logs: show asterisk container logs 
  --kamailio_logs: show container logs 
  --django_logs: show container logs 
  --django_shell: init a django shell
  --django_bash: init bash session on django container
  --rtpengine_logs: show container logs
  --rtpengine_bash: init bash session on
  --rtpengine_config: show rtpengine config
  --websockets_logs: show container logs 
  --nginx_t: print nginx container run config 
  --call_generate: generate an ibound call from PSTN-Emulator container to OMniLeads ACD 
"
    shift
    exit 1
    ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
    ;;
esac
