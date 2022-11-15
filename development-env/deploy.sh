#!/bin/bash

set -e

GREEN='\033[0;32m' # Green
RED='\033[0;31m' # Red
YELLOW='\033[1;33m' # Yellow
NC='\033[0m' # No color

#############################################################################
#############################################################################

Deploy() {
mkdir ./omnileads-repos
cd omnileads-repos

case ${os_host} in
  mac)
    brew install minio/stable/mc
  ;;
  linux)
    curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/mc
    chmod +x $HOME/minio-binaries/mc
    export PATH=$PATH:$HOME/minio-binaries/
  ;;
  win)
    echo "la ventanita del amor"
  ;;
  *)
    curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/mc
    chmod +x $HOME/minio-binaries/mc
    export PATH=$PATH:$HOME/minio-binaries/
  ;;
esac

echo "***[OML devenv] Cloning the repositories of modules"
repositories=("acd" "kamailio" "nginx" "pgsql" "rtpengine")
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
else
  git clone https://gitlab.com/omnileads/omnileads-websockets.git omlwebsockets
  git clone https://gitlab.com/omnileads/ominicontacto omlapp
fi

echo "***[OML devenv] All repositories were cloned in $(pwd)"

repositories=("acd" "kamailio" "nginx" "rtpengine" "websockets" "app" "pgsql")
for i in "${repositories[@]}"; do
cd oml${i} && git checkout oml-dev-2.0 && cd ..
done

cd ../
cp env .env
docker-compose up -d

mc alias set MINIO http://localhost:9000 minio s3minio123
mc mb MINIO/devenv
mc admin user add MINIO devenv s3devenv123
mc admin policy set MINIO readwrite user=devenv

docker-compose down
docker-compose up -d
}
#############################################################################
#############################################################################


for i in "$@"
do
  case $i in
    --os_host=mac|--os_host=linux|--os_host=win)
      os_host="${i#*=}"
      shift
    ;;
    --gitlab_clone=ssh|--gitlab_clone=https)
      gitlab_clone="${i#*=}"
      shift
    ;;
    --help|-h)
      echo "
How to use it:

./deploy.sh --os_hos= --gitlab_clone=

--os_host=
        linux
        mac
        win
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


#UserValidation
Deploy
