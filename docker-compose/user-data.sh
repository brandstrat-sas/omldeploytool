#!/bin/bash

oml_nic=eth1
env=cloud

bucket_url=${BUCKET_URL}
bucket_access_key=${BUCKET_ACCESS_KEY}
bucket_secret_key=${BUCKET_SECRET_KEY}
bucket_region=${BUCKET_REGION}
bucket_name=${BUCKET_NAME}

PRIVATE_IPV4=$(ip addr show $oml_nic | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
PUBLIC_IPV4=$(curl ifconfig.co)

# apt update && apt install git curl

# curl -fsSL https://get.docker.com -o ~/get-docker.sh
# bash ~/get-docker.sh

git clone https://gitlab.com/omnileads/omldeploytool.git 
cd ./omldeploytool/docker-compose
cp env .env

sed -i "s/ENV=devenv/ENV=$env/g" .env
sed -i "s/DJANGO_HOSTNAME=app/DJANGO_HOSTNAME=localhost/g" .env
sed -i "s/PUBLIC_IP=/PUBLIC_IP=$PUBLIC_IPV4/g" .env
sed -i "s/DAPHNE_HOSTNAME=channels/DAPHNE_HOSTNAME=localhost/g" .env
sed -i "s/ASTERISK_HOSTNAME=acd/ASTERISK_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/PGHOST=postgresql/PGHOST=localhost/g" .env
sed -i "s/WEBSOCKET_HOSTNAME=websockets/WEBSOCKET_HOSTNAME=localhost/g" .env
sed -i "s/KAMAILIO_HOSTNAME=kamailio/KAMAILIO_HOSTNAME=localhost/g" .env
sed -i "s/OMNILEADS_HOSTNAME=nginx/OMNILEADS_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/^REDIS_HOSTNAME=redis/REDIS_HOSTNAME=localhost/g" .env
sed -i "s/RTPENGINE_HOSTNAME=rtpengine/RTPENGINE_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/redis:6379/localhost:6379/g" .env

if [[ "${bucket_url}" != "NULL" ]];then
sed -i "s/CALLREC_DEVICE=s3-minio/CALLREC_DEVICE=s3/g" .env
sed -i "s/S3_BUCKET_NAME=omnileads/S3_BUCKET_NAME=$bucket_name/g" .env
sed -i "s/AWS_ACCESS_KEY_ID=omlminio/AWS_ACCESS_KEY_ID=$bucket_access_key/g" .env
sed -i "s/AWS_SECRET_ACCESS_KEY=s3omnileads123/AWS_SECRET_ACCESS_KEY=$bucket_secret_key/g" .env
sed -i "s%\S3_ENDPOINT=https://localhost%S3_ENDPOINT=$bucket_url%g" .env
    if [[ "${aws_region}" != "NULL" ]];then
        sed -i "s/bucket_region: us-east-1/bucket_region: ${aws_region}/g" .env
    fi
else
    sed -i "s%\S3_ENDPOINT=https://localhost%S3_ENDPOINT=https://$PUBLIC_IPV4%g" .env
fi

/usr/libexec/docker/cli-plugins/docker-compose -f docker-compose_prod.yml up -d

ln -s /root/omldeploytool/docker-compose/oml_manage /usr/local/bin/
ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/

#until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
#bash -x oml_manage --reset_pass

# bash -x oml_manage --init_env
