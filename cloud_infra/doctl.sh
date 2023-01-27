#!/bin/bash

case $1 in
  --create-ubuntu)
    echo "deploy: $1"
    doctl compute droplet create --image ubuntu-22-10-x64 \
    --size s-1vcpu-2gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    oml-$2
    ;;
    --create-debian)
    echo "deploy: $1"
    doctl compute droplet create --image debian-11-x64 \
    --size s-1vcpu-2gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    oml-$2
    ;;
  --create-docker)
    echo "deploy: $1"
    doctl compute droplet create --image docker-20-04 \
    --size s-2vcpu-2gb --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    --user-data-file ../docker-compose/user-data.sh \
    oml-$2
    ;;
  --create-pgsql)
    echo "deploy PGSQL: $2"
    doctl databases create oml-$2 \
    --engine pg \
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
    vultr-cli instance delete $2
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
