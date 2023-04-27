#!/bin/bash


PRIVATE_IPV4=$(ip addr show ${oml_nic} | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
PUBLIC_IPV4=$(curl ifconfig.co)

apt update 

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "alias docker-compose='/usr/libexec/docker/cli-plugins/docker-compose'" >> ~/.bashrc
source ~/.bashrc

git clone https://gitlab.com/omnileads/omldeploytool.git ~/omldeploytool
cd ~/omldeploytool/docker-compose
git checkout develop
cp env .env

sed -i -e "s/CALLREC_DEVICE=s3-minio/CALLREC_DEVICE=s3-minio/g" .env
sed -i -e "s/DJANGO_HOSTNAME=app/DJANGO_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i -e "s/DAPHNE_HOSTNAME=channels/DAPHNE_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i -e "s/ASTERISK_HOSTNAME=acd/ASTERISK_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i -e "s/PGHOST=postgresql/PGHOST=$PRIVATE_IPV4/g" .env
sed -i -e "s/WEBSOCKET_HOSTNAME=websockets/WEBSOCKET_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i -e "s/KAMAILIO_HOSTNAME=kamailio/KAMAILIO_HOSTNAME=localhost/g" .env
sed -i -e "s/OMNILEADS_HOSTNAME=nginx/OMNILEADS_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i -e "s/REDIS_HOSTNAME=redis/REDIS_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i -e "s/RTPENGINE_HOSTNAME=rtpengine/RTPENGINE_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i -e "s/REDIS_HOSTNAME=redis/REDIS_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i -e "s/minio:9000/$PRIVATE_IPV4:9000/g" .env
sed -i -e "s/redis:6379/$PRIVATE_IPV4:6379/g" .env
sed -i -e "s/S3_ENDPOINT=https://localhost/S3_ENDPOINT=https://$PUBLIC_IPV4/g" .env

docker-compose -f docker-compose_aio.yml up -d

until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
bash -x oml_manage --reset_pass

# bash -x oml_manage --init_env