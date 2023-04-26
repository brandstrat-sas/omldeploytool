#!/bin/bash

apt update && apt install docker docker-compose curl git -y

git clone https://gitlab.com/omnileads/omldeploytool.git ~/omldeploytool
cd ~/omldeploytool/docker-compose
git checkout develop
cp env .env

sed -i -e "s/S3_ENDPOINT=https://localhost/S3_ENDPOINT=https://${host_ipaddr}/g" .env

docker-compose -f docker-compose_aio.yml up -d

until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
bash -x oml_manage --reset_pass
bash -x oml_manage --init_env