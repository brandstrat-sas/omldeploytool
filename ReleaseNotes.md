# Release Notes - OMniLeads 1.33.3
[2024-02-16]

## Added

* oml-463 [DOCKER] Now it is possible to migrate to Omnileads Enterprise without editing the docker-compose YAML file.

## Improvements

* oml-463 [ANSIBLE] --rm flag added to the podman run commands launching backup & django playbooks.
* oml-463 [WEB] Startup scripts for the web app (django commands) have been modified.
* oml-463 [ANSIBLE] Order changed in the failover actions script (aio_transitions.sh).
* oml-463 [ANSIBLE] Django playbook for deploying in HA.

## Fixed

## Removed

## OMniLeads Component versions

```
    omnileads_img: docker.io/omnileads/omlapp:240201.01
    asterisk_img: docker.io/omnileads/asterisk:240102.01
    fastagi_img: docker.io/omnileads/fastagi:240104.01
    astami_img: docker.io/omnileads/astami:231230.01
    nginx_img: docker.io/omnileads/nginx:240105.01
    websockets_img: docker.io/omnileads/websockets:231125.01
    kamailio_img: docker.io/omnileads/kamailio:231125.01
    rtpengine_img: docker.io/omnileads/rtpengine:231125.01
    redis_img: docker.io/omnileads/redis:231125.01
```
