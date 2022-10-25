#!/bin/bash

case $1 in
  --create-debian)
    echo "deploy: $1"
    doctl compute droplet create --image debian-11-x64 \
    --size $3 --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    --user-data-file ./user-data.sh \
    oml-$2
    ;;
  --create-centos)
    echo "deploy: $1"
    doctl compute droplet create --image centos-7-x64 \
    --size $3 --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    --user-data-file ./user-data.sh \
    oml-$2
      ;;
  --create-pgsql)
    echo "deploy PGSQL: $1"
    doctl databases create oml-$1 \
    --engine pg
    --size $2 --region sfo3 \
    ;;
  --list)
    doctl compute droplet list
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

              -- create-os=(debian|centos)
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
