#!/bin/bash

DEPLOY_PATH=/opt

branch=${BRANCH}

PRIVATE_IPV4=$(ip addr show $oml_nic | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
PUBLIC_IPV4=$(curl ifconfig.co)

apt update && apt install -y git curl

curl -fsSL https://get.docker.com -o ~/get-docker.sh
bash ~/get-docker.sh

if [ ! -L /usr/bin/docker-compose ]; then
    ln -s /usr/libexec/docker/cli-plugins/docker-compose /usr/local/bin/
else
    echo "previus ln exist"
fi

cd $DEPLOY_PATH
git clone https://gitlab.com/omnileads/omldeploytool.git
if [ -z "$branch" ];then
    echo "main branch"
else
    echo "$branch branch"
    cd ./omldeploytool    
    git checkout $branch
    cd ..
fi

cd ./omldeploytool/docker-compose-qa
cp env .env

sed -i "s/PUBLIC_IP=/PUBLIC_IP=$PUBLIC_IPV4/g" .env
#sed -i "s/ENV=devenv/ENV=$env/g" .env

if [ ! -L /usr/bin/oml_manage ]; then
    ln -s $DEPLOY_PATH/omldeploytool/docker-compose-qa/oml_manage /usr/local/bin/oml_manage    
else
    echo "previus ln exist"
fi

/usr/libexec/docker/cli-plugins/docker-compose up -d

until curl -sk --head  --request GET https://localhost |grep "302" > /dev/null; do echo "Environment still initializing , sleeping 10 seconds"; sleep 10; done; echo "Environment is up"

./oml_manage --reset_pass
