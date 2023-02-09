#!/bin/bash

case $1 in
  install-mac)
    brew install minio/stable/mc
  ;;
  install-win)
    echo "la ventanita del amor"
  ;;
  install-linux)
    apt update && apt install -y curl 
    curl https://dl.min.io/client/mc/release/linux-amd64/mc --create-dirs -o $HOME/minio-binaries/mc
    chmod +x $HOME/minio-binaries/mc
    export PATH=$PATH:$HOME/minio-binaries/
  ;;
  *)
    echo "ERROR ERROR ERROR, you must to pass: install-linux, install-mac or install-win as parameter"
    exit 1
  ;;
esac

mc alias set MINIO http://localhost:9000 minio s3minio123
mc mb MINIO/omnileads
mc admin user add MINIO omlminio s3omnileads123
mc admin policy set MINIO readwrite user=omlminio
