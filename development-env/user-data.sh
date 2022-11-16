#!/bin/bash

git clone https://gitlab.com/omnileads/omldeploytool.git
cd ./omldeploytool
git checkout develop
cd ./development-env
./deploy.sh --os_host=linux --gitlab_clone=https
