# OMniLeads Docker Compose

* Docker Install documentation
* Docker-Compose Install documentation

Bring up your stack by running:
```
$ cp env .env
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

## Log in to the Admin UI

https://127.0.0.1

Default Admin User & Pass:

```
admin
admin
```

## Create some testing data

```
./manage --init_env
```

Default Agent User & Pass:

```
agent
agent1*
```

## Simulate calls from/to PSTN

Adittionally with omnileads container is the pstn-emulator, this an emulation of a PSTN provider,
so you can make calls via Omnileads and have different results of the call based on what you dialed
as well as generate calls from the command line to OMniLeads inbound routes.

# Dialplan outbound rules:

* Any number dialed finished with 0: PSTN is going to send you a BUSY signal
* Any number dialed finished with 1: PSTN is going to answer your call and playback audios
* Any number dialed finished with 2: PSTN will anwer your call, play short audio then hangup. This will emulate a calle hangup
* Any number dialed finished with 3: PSTN will answer your call after 35 seconds
* Any number dialed finished with 5: PSTN will make you wait 120 seconds and then hangup. This will emulate a NO_ANSWER
* Any number dialed finished with 9: PSTN will simulate a congestion

# Generate inbound calls to omnileads stack:

```
./manage --generate_call
```

## manage.sh script

This is used to launch some administration actions:

```
./manage.sh --help
```
