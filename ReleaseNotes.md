# Release Notes - OMniLeads 1.31.0
[2023-09-29]

## Added

* oml-304 - New component ASTAMI in order to interact with Asterisk AMI
* oml-304 - Daily statistics on agents and campaigns in Redis Hash for real-time views
* oml-328 - Now it's possible to have OML ACD on a network and Wombat Dialer in another network segment or external network

## Improvments

* oml-304 - [ANSIBLE] setting high performance uwsgi.ini
* oml-345 - [ANSIBLE] send container logs from stdout/sterror to journald
* oml-346 - [ANSIBLE] the upgrade and component restart are separated, allowing them to be executed separately

## Fixed

* oml-355 - RTPengine scenary for NAT onpremise deploys
* oml-35 - kamailio fix antiflood inboubd calls
* oml-310 - There is default Music On Hold (MOH) available for inbound campaigns

## Removed

* oml-345 All types of containers file logging have been removed

# OMniLeads Component versions

```
    omnileads_version: 231005.01
    asterisk_version: 230925.02
    fastagi_version: 230920.01
    astami_version: 230920.01
    nginx_version: 230923.01
    websockets_version: 230204.01
    kamailio_version: 230925.01
    rtpengine_version: 230925.01
    redis_version: 230704.01
    postgres_version: 230624.01
```
