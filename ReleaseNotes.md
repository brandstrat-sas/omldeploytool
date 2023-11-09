# Release Notes - OMniLeads 1.32.0
[2023-11-07]

## Added

* oml-418 [DEPLOY] Now CRON maintains its own versioning in Ansible (inventory.yml) and docker-compose (env).
* oml-419 [DEPLOY] New QA VPS/VM environment.

## Improvements


## Fixed

* oml-412 [DOCKER-COMPOSE] The docker-compose.yml file was adapted for PROD scenarios to the new startup scheme of the omlapp image.
* oml-416 [CRON] Processes are not terminating, leading to container blockage.
* oml-415 [ANSIBLE] update/upgrade tags for omlcron.service template render.
* oml-419 [QAEnv] Fix docker-compose.yml in order to apply new init commands.

## Removed


# OMniLeads Component versions

```
    omnileads_version: 231030.01
    omlcron_version: 230928.01
    asterisk_version: 231025.01
    fastagi_version: 230920.01
    astami_version: 230920.01
    nginx_version: 230923.01
    websockets_version: 230204.01
    kamailio_version: 230925.01
    rtpengine_version: 231030.01
    redis_version: 230704.01
    postgres_version: 230624.01
```
