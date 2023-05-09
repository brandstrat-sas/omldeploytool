#!/bin/bash

oml_nic=eth1

PRIVATE_IPV4=$(ip addr show $oml_nic | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
PUBLIC_IPV4=$(curl ifconfig.co)

apt update && apt install git curl

curl -fsSL https://get.docker.com -o ~/get-docker.sh
bash ~/get-docker.sh

git clone https://gitlab.com/omnileads/omldeploytool.git ~/omldeploytool
cd ~/omldeploytool/docker-compose
git checkout oml-289-dev-aio-compose-observability
cp env .env

sed -i "s/ENV=devenv/ENV=cloud/g" .env
sed -i "s/DJANGO_HOSTNAME=app/DJANGO_HOSTNAME=localhost/g" .env
sed -i "s/DAPHNE_HOSTNAME=channels/DAPHNE_HOSTNAME=localhost/g" .env
sed -i "s/ASTERISK_HOSTNAME=acd/ASTERISK_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/PGHOST=postgresql/PGHOST=localhost/g" .env
sed -i "s/WEBSOCKET_HOSTNAME=websockets/WEBSOCKET_HOSTNAME=localhost/g" .env
sed -i "s/KAMAILIO_HOSTNAME=kamailio/KAMAILIO_HOSTNAME=localhost/g" .env
sed -i "s/OMNILEADS_HOSTNAME=nginx/OMNILEADS_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/^REDIS_HOSTNAME=redis/REDIS_HOSTNAME=localhost/g" .env
sed -i "s/RTPENGINE_HOSTNAME=rtpengine/RTPENGINE_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/minio:9000/localhost:9000/g" .env
sed -i "s/redis:6379/localhost:6379/g" .env
sed -i "s%\S3_ENDPOINT=https://localhost%S3_ENDPOINT=https://$PUBLIC_IPV4%g" .env

/usr/libexec/docker/cli-plugins/docker-compose -f docker-compose_aio.yml up -d

ln -s /root/omldeploytool/docker-compose/oml_manage /usr/local/bin/
ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/

#until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
#bash -x oml_manage --reset_pass

# bash -x oml_manage --init_env
