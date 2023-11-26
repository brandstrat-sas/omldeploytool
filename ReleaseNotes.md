# Release Notes - OMniLeads 1.32.2
[2023-11-25]

## Added

* oml-418 [DEPLOY] Now CRON maintains its own versioning in Ansible (inventory.yml) and docker-compose (env).
* oml-419 [ANSIBLE] New QA VPS/VM environment.

## Improvements

* oml-388 [ANSIBLE] Now it's possible to automate the configuration of journalD parameters.
* oml-414 [DEPLOY] When the environment variable env=all is set, Asterisk port 5160 (Users) is opened on 0.0.0.0, allowing the use of an external RTPEngine.
* oml-414 [ACD] New asterisk version 18.20.0
* oml-414 [POSTGRES] It's no longer necessary to install the plperl extension; from now on, it's possible to use Postgres 14 in its generic version.

## Fixed

* oml-412 [DOCKER-COMPOSE] The docker-compose.yml file was adapted for PROD scenarios to the new startup scheme of the omlapp image.
* oml-416 [CRON] Processes are not terminating, leading to container blockage.
* oml-415 [ANSIBLE] update/upgrade tags for omlcron.service template render.
* oml-419 [QAEnv] Fix docker-compose.yml in order to apply new init commands.
* oml-414 [Django] Django logging is now added to stdout.

## Removed

* oml-414 [Django] Migrations related to the plperl trigger have been removed. 

# OMniLeads Component versions

```
    omnileads_version: 231125.01 
    omlcron_version: 231125.01
    asterisk_version: 231125.01
    fastagi_version: 231125.01
    astami_version: 231125.01
    nginx_version: 231125.01
    websockets_version: 231125.01
    kamailio_version: 231125.01
    rtpengine_version: 231125.01
    redis_version: 231125.01
```
