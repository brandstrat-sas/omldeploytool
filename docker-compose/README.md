#### This project is part of OMniLeads

![Diagrama deploy tool](../ansible/png/omnileads_logo_1.png)

#### 100% Open-Source Contact Center Software
#### [Community Forum](https://forum.omnileads.net/)

---

# OMniLeads Docker Compose

You need docker installed

* [Docker Install documentation](https://docs.docker.com/get-docker/)

## Setup your environment

You must create a .env variable file from the env file ready here:

Then work on it to indicate if we are going to access it directly from our workstation 
(https://localhost) or raise the stack on a virtual machine (https://hostname-or-ipaddr).


You must indicate this on the parameter, at the end of the .env file:

```
S3_ENDPOINT=https://localhost
```

Then bring up your stack by running:

```
$ docker-compose up -d
```

Data Mapping: the docker-compose scheme will map container data into docker default path volumes regarding redis, postgresql and minio objects storage.
On the other hand we have the asterisk files that will be map from the ast_cutsom_conf folder to /etc/asterisk/custom container path.

## Post docker-compose raise-up config steps:

When the minio object storage DB is first run, and then every time the volume that persists the data is deleted, them the minio_bucket.sh script must be run, in order to download the minio command line tool and then create user (key-access-id & secret-key-access) and bucket for the OMniLeads launched environment.

```
./minio_bucket.sh --install-linux

or

./minio_bucket.sh --install-mac
```


## Log in to the Admin UI

Before first time you login must to exec:

```
./manage --reset_pass
```

Then acces the URL with your browser 

https://127.0.0.1 or https://hostname-or-ipaddr 

Default Admin User & Pass:

```
admin
admin
```

Finally  you can choice a custom password. 

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


##### Dialplan outbound rules:

* Any number dialed finished with 0: PSTN is going to send you a BUSY signal
* Any number dialed finished with 1: PSTN is going to answer your call and playback audios
* Any number dialed finished with 2: PSTN will anwer your call, play short audio then hangup. This will emulate a calle hangup
* Any number dialed finished with 3: PSTN will answer your call after 35 seconds
* Any number dialed finished with 5: PSTN will make you wait 120 seconds and then hangup. This will emulate a NO_ANSWER
* Any number dialed finished with 9: PSTN will simulate a congestion

##### Generate inbound calls to omnileads stack:

```
./manage --generate_call
```

This actions will make an inbound call to the default inbound campaign created from testing data. 
You can attend the call and listen some cool music, then the recordings appear on the recordings search views. 

##### Register your SIP softphone to test the stack 

You can register a SIP account on pstn-emulator container in order to play with OMniLeads and the softphone you want. 

This are the SIP account credentials:

username: 1234567
secret: omnileads
domain: YOUR_HOSTNAME
(Change "YOUR_HOSTNAME" with the VM hostname/IPADDR  or localhost)

Then you can send calls to DID 01177660010, an also send calls from an agent to this SIP account phone calling 1234567.

## The manage.sh script

This is used to launch some administration actions like, read containers logs, delete postgres logs tables and more. 

```
./manage.sh --help
```

## Configuring wombat dialer

You only need to do this if you are going to work with Predictive Dialer campaigns

When you enter to http://localhost:8082 or http://hostname-or-ipaddr:8082 you go to Wombat Dialer to begin its configuration. 

Check our official documentation to check this: https://documentacion-omnileads.readthedocs.io/es/stable/maintance.html#configuracion-del-modulo-de-discador-predictivo

Note: when configuring initial mariadb credentials the root pass is admin123, then on the AMI connection, the server address is acd.


## Destroy and re-create all PostgreSQL backend

If you want *reset to fresh install* status launch (with the stack operative):

```
./manage.sh --clean_postgresql_db
```

Then login with *admin*, *admin* and create a new password. 
