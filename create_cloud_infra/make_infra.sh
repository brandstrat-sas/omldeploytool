#!/bin/bash

Kreator() {

ACTION=$1
NAME=$2
SIZE=$3
IMG=$4

case $ACTION in
  do-instance)
    doctl compute droplet create --image $IMG \
    --size $SIZE --region sfo3 \
    --ssh-keys ${SSH_DOCTL} $NAME
  ;;
  do-instance-aio)
    doctl compute droplet create --image $IMG \
    --size $SIZE --region sfo3 \
    --ssh-keys ${SSH_DOCTL} \
    --user-data-file ../docker-compose/user-data.sh \
    $NAME
  ;;
  do-postgres)
    doctl databases create $NAME \
    --engine pg \
    --region sfo3
  ;;
  do-list)
    doctl compute droplet list
    doctl database list
  ;;
  do-delete)
    doctl compute droplet delete $NAME
  ;;
  do-dbdelete)
    doctl database delete $NAME
  ;;
  do-dbconn)
    doctl databases connection $NAME
  ;;  
  vultr-instance)
    vultr-cli instance create --region scl \
    --plan $SIZE --os $IMG --vpc-enable true \
    --ssh-keys ${VULTR_SSH} \
    --label $NAME --ipv6 false
  ;;
  vultr-list)
    vultr-cli instance list
  ;;
  vultr-delete)
    vultr-cli instance delete $NAME
  ;;
  linode-instance)
    linode-cli linodes create --label $NAME --region us-east --image $IMG \
    --type $SIZE --private_ip true --root_pass 
  ;;
  linode-list)
    linode-cli linodes list
  ;;
  linode-delete)
    linode-cli linodes rm $NAME
  ;;
  *)
  ;;
esac
}



for i in "$@"
do
  case $i in
    --name=*)
      oml_name="${i#*=}"
      shift
    ;;
    --action=ubuntu|--action=debian|--action=rocky|--action=alma|--action=postgres|--action=bucket|--action=list|--action=delete|--action=dbconn|--action=aio-ubu|--action=dbdelete)
      oml_action="${i#*=}"
      shift
    ;;  
    --cloud=do|--cloud=vultr|--cloud=linode)
      oml_cloud="${i#*=}"
      shift
    ;;
    --size=s|--size=m|--size=l)
      oml_size="${i#*=}"
      shift
    ;;
    --help|-h)
      echo "
How to use it:

./make_infra.sh --action= --cloud= --name=  --size= 

--name=action_reference_name

--action=
        ubuntu
        debian
        rocky
        aio-ubu
        postgres
        bucket
        list
--cloud=
        do
        vultr
--size= 
        s
        m
        l
"
      shift
      exit 1
    ;;
    *)
      echo "One or more invalid options. For more information, execute: ./deploy.sh -h or ./deploy.sh --help."
      exit 1
    ;;
  esac
done

case $oml_cloud in
  do)
    case $oml_action in
      ubuntu)
        img=ubuntu-22-04-x64
        action=do-instance
      ;;
      debian)
        img=debian-11-x64
        action=do-instance
      ;;
      rocky)
        img=rockylinux-8-x64
        action=do-instance
      ;;
      aio-ubu)
        img=ubuntu-22-04-x64
        action=do-instance-aio
      ;;
      postgres)
        action=do-postgres
      ;;
      list)
        action=do-list
      ;;
      delete)
        action=do-delete
      ;;
      dbdelete)
        action=do-dbdelete
      ;;
      dbconn)
        action=do-dbconn
      ;;
      *)
        echo pepe
        exit 1
      ;;  
    esac
    case $oml_size in
      s)
        size=s-2vcpu-2gb
      ;;
      m)
        size=s-2vcpu-4gb
      ;;
      l)
        size=s-4vcpu-8gb
      ;;
      *)
        echo no size
      ;;  
    esac
  ;;
  vultr)
    case $oml_action in
      ubuntu)
        img=1743
        action=vultr-instance
      ;;
      debian)
        img=477
        action=vultr-instance
      ;;
      rocky)
        img=1869
        action=vultr-instance
      ;;
      alma)
        img=1868
        action=vultr-instance
      ;;
      aio-ubu)
        img=img=1743
        action=vultr-instance-aio
      ;;
      postgres)
        action=vultr-postgres
      ;;
      list)
        action=vultr-list
      ;;
      delete)
        action=vultr-delete
      ;;
      *)
        echo pepe
        exit 1
      ;;  
    esac
    case $oml_size in
      s)
        size=vc2-1c-1gb
      ;;
      m)
        size=vc2-2c-2gb
      ;;
      l)
        size=vc2-4c-8gb
      ;;
      *)
        echo no size
      ;;  
    esac
  ;;
  linode)
    case $oml_action in
      ubuntu)
        img=linode/ubuntu22.04
        action=linode-instance
      ;;
      debian)
        img=linode/debian11
        action=linode-instance
      ;;
      rocky)
        img=linode/rocky9
        action=linode-instance
      ;;
      alma)
        img=linode/almalinux9
        action=linode-instance
      ;;
      aio-ubu)
        img=linode/ubuntu22.04
        action=linode-instance-aio
      ;;
      postgres)
        action=linode-postgres
      ;;
      list)
        action=linode-list
      ;;
      delete)
        action=linode-delete
      ;;
      *)
        echo pepe
        exit 1
      ;;  
    esac
    case $oml_size in
      s)
        size=g6-standard-1
      ;;
      m)
        size=g6-standard-2
      ;;
      l)
        size=g6-standard-4
      ;;
      *)
        echo no size
      ;;  
    esac
  ;;
  *)
    echo "ERROR"
  ;;
esac  

Kreator "$action" "$oml_name" "$size" "$img"

# vultr_l=vc2-4c-8gb
# vultr_m=vc2-2c-2gb
# vultr_s=vc2-1c-1gb

# rocky=rockylinux-8-x64
# debian=debian-11-x64
# ubuntu=ubuntu-22-04-x64
