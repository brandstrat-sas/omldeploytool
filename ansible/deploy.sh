#!/bin/bash


set -e

GREEN='\033[0;32m' # Green
RED='\033[0;31m' # Red
YELLOW='\033[1;33m' # Yellow
NC='\033[0m' # No color
current_directory=`pwd`

#############################################################################
#############################################################################
AnsibleExec() {


echo "***************************** filter ********************************* "
echo "***************************** filter ********************************* "

case ${oml_action} in
  install)
    echo "deploy: $oml_action"
  ;;
  upgrade)
    echo "deploy: $oml_action"
  ;;
  backup)
    echo "deploy: $oml_action"
  ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
  ;;
esac

case ${oml_component} in
  voice)
    echo "install omnileads component/s $oml_component"
  ;;
  django)
    echo "install omnileads component/s $oml_component"
  ;;
  backing)
    echo "install omnileads component/s $oml_component"
  ;;
  all)
    echo "install omnileads component/s $oml_component"
    oml_component=aio
  ;;
  observability)
    echo "install omnileads component/s $oml_component"
  ;;
  asterisk)
    echo "install omnileads component/s $oml_component"
  ;;
  redis)
    echo "install omnileads component/s $oml_component"
  ;;
  pgsql)
    echo "install omnileads component/s $oml_component"
  ;;
  minio)
    echo "install omnileads component/s $oml_component"
  ;;
  nginx)
    echo "install omnileads component/s $oml_component"
  ;;
  websockets)
    echo "install omnileads component/s $oml_component"
  ;;
  kamailio)
    echo "install omnileads component/s $oml_component"
  ;;
  rtpengine)
    echo "install omnileads component/s $oml_component"
  ;;
  prometheus)
    echo "install omnileads component/s $oml_component"
  ;;
  *)
    echo "\e[31m oml_component var is unset #31 \e[0m";
  ;;
esac

echo "************************ Exec ANSIBLE matrix *************************"
echo "************************ Exec ANSIBLE matrix *************************"

sleep 2


cp instances/$oml_tenant/inventory.yml inventory.yml

ansible-playbook matrix.yml --extra-vars \
  "django_repo_path=$(pwd)/components/django/ \
  redis_repo_path=$(pwd)/components/redis/ \
  pgsql_repo_path=$(pwd)/components/postgresql/ \
  kamailio_repo_path=$(pwd)/components/kamailio/ \
  asterisk_repo_path=$(pwd)/components/asterisk/ \
  rtpengine_repo_path=$(pwd)/components/rtpengine/ \
  websockets_repo_path=$(pwd)/components/websockets/ \
  nginx_repo_path=$(pwd)/components/nginx/ \
  minio_repo_path=$(pwd)/components/minio/ \
  observability_repo_path=$(pwd)/components/observability/ \
  rebrand=false \
  tenant_folder=$oml_tenant \
  commit=ascd \
  build_date=\"$(env LC_hosts=C LC_TIME=C date)\"" \
  --tags "$oml_action, $oml_component" \
  -i inventory.yml -k

ResultadoAnsible=`echo $?`

if [ $ResultadoAnsible == 0 ];then
  echo "
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@/@@@@/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@/@/@////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@/@@@/@@@/@@@@@@@/@@@@/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@@@/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@@@@@@@@@@@@@
  @@@@@@/@@@/@@@/@@@@@@@/@@@@/@@@@@@@//@@@@@/@@@///@@@@@&//@@@@@@@@@@@@@@@@/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/@@@@@@@@@@@@@
  @@@@@@@@/@/@@@&/@@//@@@(@/@@@@@@@@/@@@@@@@@/@@////@@@@/@/@@@//@@@/@@@/@@@/@@@@@@@//@@@/@@@/@@@/@@@//@@@///@@/@@@/@@@@@@
  @@@@@@@@/@@/&//%//@/@//@@/@@@@@@@@/@@@@@@@@/%@//@//@@/@@/@@@/@@@@//@@/@@@/@@@@@@/@@@//@@@@@/////@/@@@@@@#/@@///@@@@@@@@
  @@@@@@@////@/@@////@@/@///@@@@@@@@//@@@@@@//@@//@@/@/@@@/@@@/@@@@//@@/@@@/@@@@@@///@@@@/@/@@@@@/@@/@@@@@//@@@@@@/@@@@@@
  @@@@@@/@@@//@//@@@@/@@/@@@@/@@@@@@@@//////@@@@//@@@/@@@@/@@@/@@@@//@@/@@@///////@@////@@@@////@/@@@/////@/@@/////@@@@@@
  @@@@@@/@@@//@@@@@@/@@@//@@/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@/@@@//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@/@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                                          The Open Source Contact Center Solution
                                           Copyright (C) 2018 Freetech Solutions"
  echo ""
  echo "#############################################################"
  echo "#         OMniLeads installation ended successfully         #"
  echo "#############################################################"
  echo ""
  git checkout inventory.yml
else
  echo ""
  echo "#######################################################################################"
  echo "#         OMniLeads installation failed. Check what happened and try it again         #"
  echo "#######################################################################################"
  echo ""
  git checkout inventory.yml
fi
}



for i in "$@"
do
  case $i in
    --action=upgrade|--action=install|--action=backup)
      oml_action="${i#*=}"
      shift
    ;;
    --component=aio|--component=app|--component=voice|--component=backing|--component=observability|--component=django|--component=asterisk|--component=kamailio|--component=rtpengine|--component=redis|--component=pgsql|--component=minio|--component=haproxy|--component=websockets|--component=nginx|--component=prometheus|--component=all)
      oml_component="${i#*=}"
      shift
    ;;
    --tenant=*)
      oml_tenant="${i#*=}"
      shift
    ;;
    --help|-h)
      echo "
How to use it:

./deploy.sh --action= --component= --tenant=

--action=
        install
        upgrade
        backup
--component=
        aio
        app
        backing
        voice
        monitoring
        django
        asterisk
        kamailio
        rtpengine
        redis
        pgsql
        minio
        haproxy
        websockets
        nginx
        observability
--tenant=
        Name of tenant instances folder.
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


#UserValidation
AnsibleExec
