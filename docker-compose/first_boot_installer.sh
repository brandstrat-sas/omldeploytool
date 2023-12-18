#!/bin/bash

oml_nic=${NIC}
env=${ENV}
branch=${BRANCH}
bucket_url=${BUCKET_URL}
bucket_access_key=${BUCKET_ACCESS_KEY}
bucket_secret_key=${BUCKET_SECRET_KEY}
bucket_region=${BUCKET_REGION}
bucket_name=${BUCKET_NAME}
dialer_host=${DIALER_HOST}
dialer_user=${DIALER_USER}
dialer_pass=${DIALER_PASS}
postgres_host=${PGSQL_HOST}
postgres_port=${PGSQL_PORT}
postgres_user=${PGSQL_USER}
postgres_password=${PGSQL_PASSWORD}
postgres_db=${PGDATABASE}

PRIVATE_IPV4=$(ip addr show $oml_nic | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
PUBLIC_IPV4=$(curl ifconfig.co)

# Obtener el ID de la distribución del sistema operativo
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_ID=$ID
else
    echo "No se puede determinar el sistema operativo."
    exit 1
fi

# Debian family
if [ "$OS_ID" = "debian" ] || [ "$OS_ID" = "ubuntu" ]; then    
    apt update && apt install -y git
    curl -fsSL https://get.docker.com -o ~/get-docker.sh
    bash ~/get-docker.sh    

# Redhat family
elif [ "$OS_ID" = "rhel" ] || [ "$OS_ID" = "almalinux" ] || [ "$OS_ID" = "rocky" ] || [ "$OS_ID" = "centos" ]; then
    dnf check-update
    dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin git
    systemctl start docker
    systemctl enable docker

else
    echo "Distribución no soportada."
    exit 1
fi

ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/bin/

git clone https://gitlab.com/omnileads/omldeploytool.git

if [ -z "$branch" ];then
    echo deploy a main branch
else
    echo "deploy a $branch branch"
    cd ./omldeploytool    
    git checkout $branch
    cd ..
fi

cd ./omldeploytool/docker-compose
cp env .env

sed -i "s/ENV=devenv/ENV=$env/g" .env
sed -i "s/DJANGO_HOSTNAME=app/DJANGO_HOSTNAME=localhost/g" .env
sed -i "s/PUBLIC_IP=/PUBLIC_IP=$PUBLIC_IPV4/g" .env
sed -i "s/DAPHNE_HOSTNAME=channels/DAPHNE_HOSTNAME=localhost/g" .env
sed -i "s/ASTERISK_HOSTNAME=acd/ASTERISK_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/FASTAGI_HOSTNAME=fastagi/FASTAGI_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/WEBSOCKET_HOSTNAME=websockets/WEBSOCKET_HOSTNAME=localhost/g" .env
sed -i "s/KAMAILIO_HOSTNAME=kamailio/KAMAILIO_HOSTNAME=localhost/g" .env
sed -i "s/OMNILEADS_HOSTNAME=nginx/OMNILEADS_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/^REDIS_HOSTNAME=redis/REDIS_HOSTNAME=localhost/g" .env
sed -i "s/RTPENGINE_HOSTNAME=rtpengine/RTPENGINE_HOSTNAME=$PRIVATE_IPV4/g" .env
sed -i "s/redis:6379/localhost:6379/g" .env

if [ ! -z "$dialer_host" ];then
    sed -i "s/WOMBAT_HOSTNAME=wombat/WOMBAT_HOSTNAME=$dialer_host/g" .env
    sed -i "s/WOMBAT_USER=demoadmin/WOMBAT_USER=$dialer_user/g" .env
    sed -i "s/WOMBAT_PASSWORD=demo/WOMBAT_PASSWORD=$dialer_pass/g" .env    
fi

# AIO 
if [[ -z "$bucket_url" && -z "$postgres_host" ]]; then
    if [[ "$ENV" == "cloud" ]];then
        sed -i "s%\S3_ENDPOINT=https://localhost%S3_ENDPOINT=https://$PUBLIC_IPV4%g" .env
    elif [[ "$ENV" == "lan" ]];then    
        sed -i "s%\S3_ENDPOINT=https://localhost%S3_ENDPOINT=https://$PRIVATE_IPV4%g" .env
    elif [[ "$ENV" == "nat" ]];then    
        sed -i "s%\S3_ENDPOINT=https://localhost%S3_ENDPOINT=https://$PRIVATE_IPV4%g" .env
    fi    
    sed -i "s/minio:9000/localhost:9000/g" .env
    sed -i "s/PGHOST=postgresql/PGHOST=localhost/g" .env
    /usr/libexec/docker/cli-plugins/docker-compose -f docker-compose_prod.yml up -d
# AIO con bucket externo    
elif [[ -n "$bucket_url" && -z "$postgres_host" ]]; then
    sed -i "s/CALLREC_DEVICE=s3-minio/CALLREC_DEVICE=s3/g" .env
    sed -i "s/S3_BUCKET_NAME=omnileads/S3_BUCKET_NAME=$bucket_name/g" .env
    sed -i "s/AWS_ACCESS_KEY_ID=omlminio/AWS_ACCESS_KEY_ID=$bucket_access_key/g" .env
    sed -i "s%\AWS_SECRET_ACCESS_KEY=s3omnileads123%AWS_SECRET_ACCESS_KEY=$bucket_secret_key%g" .env
    sed -i "s%\S3_ENDPOINT=https://localhost%S3_ENDPOINT=$bucket_url%g" .env
        if [[ "${aws_region}" != "NULL" ]];then
            sed -i "s/bucket_region: us-east-1/bucket_region: ${aws_region}/g" .env
        fi
    sed -i "s/PGHOST=postgresql/PGHOST=localhost/g" .env    
    /usr/libexec/docker/cli-plugins/docker-compose -f docker-compose_prod_external_bucket.yml up -d
# AIO con bucket externo y postgres externo    
elif [[ -n "$bucket_url" && -n "$postgres_host" ]]; then
    sed -i "s/PGHOST=postgresql/PGHOST=$postgres_host/g" .env
    sed -i "s/PGPORT=5432/PGPORT=$postgres_port/g" .env
    sed -i "s/PGUSER=omnileads/PGUSER=$postgres_user/g" .env
    sed -i "s/PGPASSWORD=admin123/PGPASSWORD=$postgres_password/g" .env
    sed -i "s/PGDATABASE=omnileads/PGDATABASE=$postgres_db/g" .env
    sed -i "s/CALLREC_DEVICE=s3-minio/CALLREC_DEVICE=s3/g" .env
    sed -i "s/S3_BUCKET_NAME=omnileads/S3_BUCKET_NAME=$bucket_name/g" .env
    sed -i "s/AWS_ACCESS_KEY_ID=omlminio/AWS_ACCESS_KEY_ID=$bucket_access_key/g" .env
    sed -i "s%\AWS_SECRET_ACCESS_KEY=s3omnileads123%AWS_SECRET_ACCESS_KEY=$bucket_secret_key%g" .env
    sed -i "s%\S3_ENDPOINT=https://localhost%S3_ENDPOINT=$bucket_url%g" .env
        if [[ "${aws_region}" != "NULL" ]];then
            sed -i "s/bucket_region: us-east-1/bucket_region: ${aws_region}/g" .env
        fi
    /usr/libexec/docker/cli-plugins/docker-compose -f docker-compose_prod_external.yml up -d
else
    exit 0
fi

ln -s ./omldeploytool/docker-compose/oml_manage /usr/bin/

if [[ "$ENV" == "devenv" ]];then
    until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
elif [[ "$ENV" == "lan" ]];then
    until curl -sk --head  --request GET https://$PRIVATE_IPV4 |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
else
    until curl -sk --head  --request GET https://$PUBLIC_IPV4 |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"
fi

./oml_manage --reset_pass
