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
  app)
    echo "deploy: $oml_action"
  ;;
  voice)
    echo "deploy: $oml_action"
  ;;
  postgres)
    echo "deploy: $oml_action"
  ;;
  observability)
    echo "deploy: $oml_action"
  ;;
  haproxy)
    echo "deploy: $oml_action"
  ;;
  cron)
    echo "deploy: $oml_action"
  ;;
  keepalived)
    echo "deploy: $oml_action"
  ;;
  kamailio)
    echo "deploy: $oml_action"
  ;;
  rtpengine)
    echo "deploy: $oml_action"
  ;;
  asterisk)
    echo "deploy: $oml_action"
  ;;
  sentinel)
    echo "deploy: $oml_action"
  ;;
  pgsql_node_recovery_main)
    echo "deploy: $oml_action"
  ;;
  pgsql_node_takeover_main)
    echo "deploy: $oml_action"
  ;;
  redis_node_takeover_main)
    echo "deploy: $oml_action"
  ;;
  *)
    echo "ERROR oml_action var is unset";
    exit 1
  ;;
esac

echo "************************ Exec ANSIBLE matrix *************************"
echo "************************ Exec ANSIBLE matrix *************************"

cp instances/$oml_tenant/inventory.yml .inventory.yml
sleep 1

case ${oml_action} in
  pgsql_node_recovery_main)
    ansible-playbook ./components/postgresql/recovery_main_node.yml --extra-vars \
    "pgsql_repo_path=$(pwd)/components/postgresql/
    tenant_folder=$oml_tenant \
    commit=ascd " \
    --tags $oml_action \
    -i .inventory.yml
    Banner `echo $?`
  ;;
  pgsql_node_takeover_main)
    ansible-playbook ./components/postgresql/takeover_main_node.yml --extra-vars \
    "pgsql_repo_path=$(pwd)/components/postgresql/
    tenant_folder=$oml_tenant \
    commit=ascd " \
    --tags $oml_action \
    -i .inventory.yml
    Banner `echo $?`
  ;;
  pgsql_node_recovery_backup)
    ansible-playbook ./components/postgresql/recovery_main_node.yml --extra-vars \
    "pgsql_repo_path=$(pwd)/components/postgresql/
    tenant_folder=$oml_tenant \
    commit=ascd " \
    --tags $oml_action \
    -i .inventory.yml
    Banner `echo $?`
  ;;
  redis_node_takeover_main)
    ansible-playbook ./components/sentinel/takeover_main_node.yml --extra-vars \
    "pgsql_repo_path=$(pwd)/components/postgresql/
    tenant_folder=$oml_tenant \
    commit=ascd " \
    --tags $oml_action \
    -i .inventory.yml
    Banner `echo $?`
  ;;
  *)
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
    haproxy_repo_path=$(pwd)/components/haproxy/ \
    cron_repo_path=$(pwd)/components/cron/ \
    sentinel_repo_path=$(pwd)/components/sentinel/ \
    daphne_repo_path=$(pwd)/components/daphne/ \
    keepalived_repo_path=$(pwd)/components/keepalived/ \
    pstn_repo_path=$(pwd)/components/pstn_emulator/ \
    addons_repo_path=$(pwd)/components/addons/ \
    observability_repo_path=$(pwd)/components/observability/ \
    rebrand=false \
    tenant_folder=$oml_tenant \
    commit=ascd \
    build_date=\"$(env LC_hosts=C LC_TIME=C date)\"" \
    --tags "$oml_action" \
    -i .inventory.yml
    Banner `echo $?`
  ;;
esac

}

Banner () {
if [ $1 == 0 ];then
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
                                           Copyright (C) 2023 Freetech Solutions"
  echo ""
  echo "#############################################################"
  echo "#         OMniLeads installation ended successfully         #"
  echo "#############################################################"
  echo ""
else
  echo ""
  echo "#######################################################################################"
  echo "#         OMniLeads installation failed. Check what happened and try it again         #"
  echo "#######################################################################################"
  echo ""
fi
}

for i in "$@"
do
  case $i in
    --action=upgrade|--action=install|--action=backup|--action=voice|--action=app|--action=observability|--action=postgres|--action=haproxy|--action=cron|--action=keepalived|--action=kamailio|--action=rtpengine|--action=asterisk|--action=sentinel|--action=pgsql_node_recovery_main|--action=pgsql_node_takeover_main|--action=redis_node_takeover_main|--action=pgsql_node_recovery_backup)
      oml_action="${i#*=}"
      shift
    ;;
    --tenant=*)
      oml_tenant="${i#*=}"
      shift
    ;;
    --help|-h)
      echo "
How to use it:

./deploy.sh --action= --tenant=

--action=
        install
        upgrade
        backup
        voice
        app
        observability
        postgres
        sentinel
        redis
        pgsql_node_recovery_main
        pgsql_node_takeover_main
        redis_node_takeover_main
        pgsql_node_recovery_backup
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

AnsibleExec
    