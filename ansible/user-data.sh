#!/bin/bash

set -e

GREEN='\033[0;32m' # Green
RED='\033[0;31m' # Red
YELLOW='\033[1;33m' # Yellow
NC='\033[0m' # No color
current_directory=`pwd`

#export oml_infra=
#export oml_action=
#export oml_component=
#export oml_repo_branch=
#export oml_env=

#export omlapp_img=
#export asterisk_img=
#export kamailio_img=
#export rtpengine_img=
#export websockets_img=

#export oml_pgsql_cloud=
#export oml_pgsql_ssl=
#export oml_pgsql_db=
#export oml_pgsql_user=
#export oml_pgsql_password=
#export oml_pgsql_host=
#export oml_pgsql_port=

#export bucket_access_key=
#export bucket_secret_key=
#export bucket_name=
#export bucket_url=
#export bucket_region=

echo "************************ install and clone ************************* \n"
echo ""
echo "************************ install and clone ************************* \n"
apt update && apt install -y ansible git

rm -rf /opt/omldeploy
cd /opt/
git clone --branch ${oml_repo_branch} https://gitlab.com/omnileads/omldeploy.git
cd omldeploy/ansible

echo "************************ net discover ************************* \n"
echo ""
echo "************************ net discover ************************* \n"
case ${oml_infra} in
  gcp)
    PRIVATE_IPV4=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)
    PUBLIC_IPV4=$(curl -s -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)
    ;;
  aws)
    PRIVATE_IPV4=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
    PUBLIC_IPV4=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
    ;;
  azure)
    PRIVATE_IPV4=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2017-08-01&format=text")
    PUBLIC_IPV4=$(curl -H Metadata:true "http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/publicIpAddress?api-version=2017-08-01&format=text")
    ;;
  digitalocean)
    echo -n "DigitalOcean"
    PUBLIC_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
    PRIVATE_IPV4=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)
    ;;
  linode)
    echo -n "Linode"
    PRIVATE_IPV4=$(ip addr show ${oml_nic} | grep "192.168" | awk '{print $2}' | awk -F/ '{print $1}')
    IPADDR_MASK=$(ip addr show ${oml_nic} | grep "192.168" | awk '{print $2}')
    ;;
  onpremise)
    echo "Onpremise Deploy \n"
    PRIVATE_IPV4=$(ip addr show ${oml_nic} | grep inet |grep -v inet6 | awk '{print $2}' | cut -d/ -f1)
    PUBLIC_IPV4=$(curl -s http://ipinfo.io/ip)
    ;;
  *)
    echo -n "you must to declare STAGE variable"
    exit 1
    ;;
esac

echo "******************** inventory setting ********************"
echo ""
echo "******************** inventory setting ********************"
echo ""

sed -i "s/#localhost/localhost/g" ./inventory

# # container IMAGES edit inventory params ***************************************************
if [ "${omlapp_img}" ]; then
  sed -i "s/virtualenv_version=latest/virtualenv_version=${omlapp_img}/g" ./inventory
fi
if [ "${websockets_img}" ]; then
  sed -i "s/websockets_version=latest/websockets_version=${websockets_img}/g" ./inventory
fi
if [ "${nginx_img}" ]; then
  sed -i "s/nginx_version=latest/nginx_version=${nginx_img}/g" ./inventory
fi
if [ "${asterisk_img}" ]; then
  sed -i "s/asterisk_version=latest/asterisk_version=${asterisk_img}/g" ./inventory
fi
if [ "${kamailio_img}" ]; then
  sed -i "s/kamailio_version=latest/kamailio_version=${kamailio_img}/g" ./inventory
fi
if [ "${rtpengine_img}" ]; then
  sed -i "s/rtpengine_version=latest/rtpengine_version=${rtpengine_img}/g" ./inventory
fi

# # PGSQL edit inventory params **************************************************************
if [ "${oml_pgsql_ssl}" ]; then
  sed -i "s/postgres_ssl=false/postgres_ssl=true/g" ./inventory
fi
if [ "${oml_pgsql_cloud}" ]; then
  sed -i "s/postgres_cloud=false/postgres_cloud=true/g" ./inventory
fi
if [ "${oml_pgsql_db}" ]; then
  sed -i "s/postgres_database=omnileads/postgres_database=${oml_pgsql_db}/g" ./inventory
fi
if [ "${oml_pgsql_user}" ]; then
  sed -i "s/postgres_user=omnileads/postgres_user=${oml_pgsql_user}/g" ./inventory
fi
if [ "${oml_pgsql_password}" ] ;then
  sed -i "s/postgres_password=AVNS_m0GH-Fk0ZXWWOxNWdSY/postgres_password=${oml_pgsql_password}/g" ./inventory
fi
if [ "${oml_pgsql_host}" ]; then
  sed -i "s/#postgres_host=/postgres_host=${oml_pgsql_host}/g" ./inventory
  sed -i "s/#postgres_local=false/postgres_local=false/g" ./inventory
fi
if [ "${oml_pgsql_port}" ]; then
  sed -i "s/postgres_port=5432/postgres_port=${oml_pgsql_port}/g" ./inventory
fi

# # BUCKET edit inventory params **************************************************

if [ "${bucket_access_key}" ]; then
sed -i "s%\bucket_access_key=dsadsadsad%bucket_access_key=${bucket_access_key}%g" ./inventory
fi
if [ "${bucket_secret_key}" ]; then
sed -i "s%\bucket_secret_key=BNVBNbnvghfhg76574632ghfgh%bucket_secret_key=${bucket_secret_key}%g" ./inventory
fi
if [ "${bucket_name}" ]; then
sed -i "s%\bucket_name=omnileads%bucket_name=${bucket_name}%g" ./inventory
fi
if [ "${bucket_url}" ]; then
sed -i "s%\#bucket_url=%bucket_url=${bucket_url}%g" ./inventory
fi
if [ "${bucket_region}" ]; then
sed -i "s%\bucket_region=us-east-1%bucket_region=${bucket_region}%g" ./inventory
fi

./deploy.sh --action=${oml_action} --component=${oml_component} --lan_ip=$PRIVATE_IPV4 --wan_ip=$PUBLIC_IPV4 --infra=${oml_env}
