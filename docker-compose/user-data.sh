#!/bin/bash

# values: linux or mac
OS=linux
ASTERISK_AUDIO_PROMPTS=https://downloads.asterisk.org/pub/telephony/sounds/asterisk-core-sounds-en-alaw-current.tar.gz
OMNILEADS_AUDIO_PROMPTS=https://fts-public-packages.s3-sa-east-1.amazonaws.com/asterisk/asterisk-oml-sounds-current.tar.gz

if [ "$OS" == "mac" ]; then
  brew install minio/stable/mc
else
  curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/mc
  chmod +x $HOME/minio-binaries/mc
  export PATH=$PATH:$HOME/minio-binaries/
fi

git clone https://gitlab.com/omnileads/omldeploytool.git
cd ./omldeploytool/
git checkout develop
cd docker-compose
docker-compose up -d

mc alias set MINIO http://localhost:9000 minio s3minio123
mc mb MINIO/omnileads
mc admin user add MINIO omlminio s3omnileads123
mc admin policy set MINIO readwrite user=omlminio

docker-compose down
docker-compose up -d
