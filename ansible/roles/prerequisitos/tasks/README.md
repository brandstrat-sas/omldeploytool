# OMniLeads Docker Compose

This repository provides ready-to-run OMniLeads recipes using Docker and docker-compose
To start your own bundle or choice, just run the following command inside the selected directory:

```
$ docker-compose up -d
```

Data Mapping: the docker-compose scheme will map container data into docker default path volumes regarding redis, postgresql and minio objects storage.
On the other hand we have the asterisk files that will be map from the ast_cutsom_conf folder to /etc/asterisk/custom container path.

## Post raise up config:

When the minio object storage DB is first run, and then every time the volume that persists the data is deleted, them the minio_bucket.sh script must be run,
in order to create user and bucket.

```
./minio_bucket.sh
```

The first time raise up the stack or every time you delete PostgreSQL databases , you must to launch ./manage.sh --reset_pass in order to put admin admin user credentials.

```
./manage.sh --reset_pass
```

## manage.sh script

This is used to launch some administration actions:

- reset django admin password
- drop all postgres databases
- drop all redis cache
