#!/bin/bash

# values: linux or mac
OS=linux

apt update && apt install docker-compose -y

if [ "$OS" == "mac" ]; then
  brew install minio/stable/mc
else
  curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/mc
  chmod +x $HOME/minio-binaries/mc
  export PATH=$PATH:$HOME/minio-binaries/
fi

git clone https://gitlab.com/omnileads/omldeploytool.git
cd ./omldeploytool/docker-compose
git checkout develop
cp env .env
sed -i -e "s/RTPENGINE_ENV=devenv/RTPENGINE_ENV=docker-cloud/g" .env
docker-compose up -d

mc alias set MINIO http://localhost:9000 minio s3minio123
mc mb MINIO/omnileads
mc admin user add MINIO omlminio s3omnileads123
mc admin policy set MINIO readwrite user=omlminio

until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
