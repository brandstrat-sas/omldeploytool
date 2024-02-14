# Release Notes - OMniLeads 1.33.3
[2024-03-05]

## Added

## Improvements

* oml-463 [DOCKER] Now it is possible to migrate to OMniLeads Enterprise without editing the docker-compose YAML file.
* oml-463 [ANSIBLE] the "--rm" flag added to the podman run commands launching backup & django playbooks.
* oml-463 [WEB] [HA] Startup scripts for the web app UWSGI (django commands) have been modified.
* oml-463 [ANSIBLE] [HA] Order changed in the failover actions script (aio_transitions.sh).
* oml-463 [ANSIBLE] [HA] Django, Asterisk, Cron & Nginx components playbook for deploying in HA.

## Fixed

* oml-475 [ASTERISK] Calls that start on one day and end on the next cannot be played back or downloaded.

## Removed

* oml-463 [ANSIBLE] Now it is possible to migrate to Omnileads Enterprise without inventory.yml flag "enterprise_edition:"

## OMniLeads Component versions

```
    omnileads_img: docker.io/omnileads/omlapp:240216.01
    asterisk_img: docker.io/omnileads/asterisk:240226.01
    fastagi_img: docker.io/omnileads/fastagi:240128.01
    astami_img: docker.io/omnileads/astami:231230.01
    nginx_img: docker.io/omnileads/nginx:240105.01
    websockets_img: docker.io/omnileads/websockets:231125.01
    kamailio_img: docker.io/omnileads/kamailio:231125.01
    rtpengine_img: docker.io/omnileads/rtpengine:231125.01
    redis_img: docker.io/omnileads/redis:231125.01
```
