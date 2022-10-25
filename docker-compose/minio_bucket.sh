#!/bin/bash

mc alias set MINIO http://localhost:9000 minio s3minio123
mc mb MINIO/omnileads
mc admin user add MINIO omlminio s3omnileads123
mc admin policy set MINIO readwrite user=omlminio
