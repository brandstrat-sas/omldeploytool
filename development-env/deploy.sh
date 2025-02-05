#!/bin/bash

set -e

GREEN='\033[0;32m' # Green
RED='\033[0;31m' # Red
YELLOW='\033[1;33m' # Yellow
NC='\033[0m' # No color

#############################################################################
#############################################################################

Deploy() {

if [ ! -d omnileads-repos ]
then
  mkdir omnileads-repos
fi

cd omnileads-repos

echo "***[OML devenv] Cloning the repositories of modules"
repositories=("acd" "kamailio" "nginx" "pgsql" "rtpengine" "fastagi" "ami" "redis" "pgsql" "_interactions_processor" "_sentiment_analysis")
for i in "${repositories[@]}"; do
  if [ ! -d "oml${i}" ]; then
    if [ "$gitlab_clone" == "ssh" ]; then
      git clone git@gitlab.com:omnileads/oml$i.git
    else
      git clone https://gitlab.com/omnileads/oml$i.git
    fi
  else
    echo "***[OML devenv] $i repository already cloned"
  fi
done

if [ "$gitlab_clone" == "ssh" ]; then
  git clone git@gitlab.com:omnileads/omnileads-websockets.git omlwebsockets
  git clone git@gitlab.com:omnileads/ominicontacto omlapp
  git clone git@gitlab.com:omnileads/oml_sentiment_analysis
else
  git clone https://gitlab.com/omnileads/omnileads-websockets.git omlwebsockets
  git clone https://gitlab.com/omnileads/ominicontacto omlapp
fi

# Addons
if [ "$gitlab_clone" == "ssh" ]; then
  git clone git@gitlab.com:omnileads/premium_reports_app.git
  git clone git@gitlab.com:omnileads/wallboard_app.git
  git clone git@gitlab.com:omnileads/survey_app.git
  git clone git@gitlab.com:omnileads/webphone_client_app.git
fi

echo "********* [OML devenv] All repositories were cloned in $(pwd)"
sleep 5

repositories=("acd" "kamailio" "nginx" "rtpengine" "websockets")
for i in "${repositories[@]}"; do
cd oml${i} && git checkout master-2.0 && cd ..
done

cd ../
cp env .env
docker-compose pull
docker-compose up -d --no-build

}

#############################################################################
#############################################################################

for i in "$@"
do
  case $i in
    --gitlab_clone=ssh|--gitlab_clone=https)
      gitlab_clone="${i#*=}"
      shift
    ;;
    --help|-h)
      echo "
How to use it:

./deploy.sh --gitlab_clone=

--gitlab_clone=
        ssh
        https
"
      shift
      exit 1
    ;;
    *)
      echo "default params are --os_host linux and gitlab_clone https"
    ;;
  esac
done

Deploy
