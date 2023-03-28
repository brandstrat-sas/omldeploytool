#!/bin/bash

# values: linux or mac
OS=linux

host_ipaddr=172.16.101.14

apt update && apt install docker-compose curl -y

if [ "$OS" == "mac" ]; then
  brew install minio/stable/mc
else
  curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/minio_cmd
  chmod +x $HOME/minio-binaries/minio_cmd
  export PATH=$PATH:$HOME/minio-binaries/
fi

git clone https://gitlab.com/omnileads/omldeploytool.git ~/omldeploytool
cd ~/omldeploytool/docker-compose
git checkout develop
cp env .env

sed -i -e "s/S3_ENDPOINT=https://localhost/S3_ENDPOINT=https://${host_ipaddr}/g" .env

docker-compose up -d

minio_cmd alias set MINIO http://localhost:9000 minio s3minio123
minio_cmd mb MINIO/omnileads
minio_cmd admin user add MINIO omlminio s3omnileads123
minio_cmd admin policy set MINIO readwrite user=omlminio

until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py cambiar_admin_password
docker exec -it oml-django python3 /opt/omnileads/ominicontacto/manage.py inicializar_entorno
