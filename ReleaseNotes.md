# Release Notes 
[2023-07-17]

## Added

* oml-302 - [ANSIBLE] Prometheus agent for Redis
* oml-302 - [ANSIBLE] Prometheus agent for Postgres
* oml-302 - [ANSIBLE] Homer SIP capture integration to extract SIP/RTP metrics from Asterisk
* oml-301 - [ANSIBLE] Logs cleaner CRON

## Changed

* oml-191 - [ANSIBLE] Migrate image version tags to inventory.yml

## Fixed

* oml-302 - [ANSIBLE] promtail.yml config file
* oml-191 - [ANSIBLE] Change task order for Postgres task create plperl 

## Removed

No removals in this release.

# Compatibility versions

```
    omnileads_version: 1.29.0
    asterisk_version: 230715.01
    fastagi_version: 230703.01
    nginx_version: 230215.01    
    websockets_version: 230204.01    
    kamailio_version: 230204.01    
    rtpengine_version: 230606.01
    redis_version: 230704.01
    postgres_version: 230624.01
```
