#!/bin/bash

case $1 in
  --create-swarm)
    echo "deploy: $1"
    doctl compute droplet create --image ubuntu-22-04-x64 \
    --size s-1vcpu-2gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    --user-data-file ../docker-swarm/user-data.sh \
    $2-$3
    ;;
  --create-swarm-worker)
    echo "deploy: $1"
    doctl compute droplet create --image ubuntu-22-04-x64 \
    --size s-1vcpu-2gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    --user-data-file ../docker-swarm/user-data-worker.sh \
    $2-$3
    ;;  
  --create-debian)
    echo "deploy: $1"
    doctl compute droplet create --image debian-11-x64 \
    --size s-4vcpu-8gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    oml-$2
    ;;
  --create-centos)
    echo "deploy: $1"
    doctl compute droplet create --image centos-7-x64 \
    --size s-1vcpu-1gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    oml-$2
    ;;
  --create-rocky)
    echo "deploy: $1"
    doctl compute droplet create --image rockylinux-8-x64 \
    --size s-2vcpu-4gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    oml-$2
    ;;  
  --create-docker)
    echo "deploy: $1 nic: $2"
    doctl compute droplet create --image debian-11-x64 \
    --size s-4vcpu-8gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    --user-data-file ../docker-compose/user-data.sh \
    oml-$2
    ;;
  --create-devenv)
    echo "deploy: $1"
    doctl compute droplet create --image docker-20-04 \
    --size s-2vcpu-2gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    --user-data-file ../development-env/user-data.sh \
    oml-$2
    ;;
  --create-postgres)
    echo "deploy PGSQL: $2"
    doctl databases create oml-$2 \
    --engine pg \
    --region sfo3
    ;;
  --add-firewall)
    echo "deploy PGSQL: $2"
    doctl compute firewall add-droplets $1 $2
    --region sfo3
    ;;    
  --list)
    doctl compute droplet list
    ;;
  --dblist)
    doctl database list
    ;;
  --dbconn)
    doctl database connection $2
    ;;
  --dbdelete)
    doctl database delete $2
    ;;
  --delete)
    doctl compute droplet delete $2
    ;;
  --help)
    echo "
      DigitalOcean droplet kreator
      ----------------------------
      ----------------------------
      How to use it:
            ./doctl.sh --create-os $name

              -- create-os=(debian|docker)
              -- $name: the name of the droplet

            ./doctl.sh --list
              in order to list all droplts

            ./doctl.sh --delete id
              id: the id of the droplet
         "
    shift
    exit 1
    ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
    ;;
esac
