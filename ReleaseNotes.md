# Release Notes - OMniLeads 1.33.2
[2024-01-18]

## Added


## Improvements

* oml-460 [ANSIBLE]: Images for each component are now referenced using the syntax: url_registry/repo/component:tag (for example: docker.io/omnileads/omlapp:231227.01).

## Fixed

* oml-2555 [WEB]: Fixed an error when rescheduling a contact previously qualified by another agent.
* oml-460 [DEPLOY]: Added the "NAT" scenario to the deployment with first_boot_installer.sh (docker-compose).

## Removed


# OMniLeads Component versions

```
    omnileads_img: docker.io/omnileads/omlapp:240117.01
    asterisk_img: docker.io/omnileads/asterisk:240102.01
    fastagi_img: docker.io/omnileads/fastagi:240104.01
    astami_img: docker.io/omnileads/astami:231230.01
    nginx_img: docker.io/omnileads/nginx:240105.01
    websockets_img: docker.io/omnileads/websockets:231125.01
    kamailio_img: docker.io/omnileads/kamailio:231125.01
    rtpengine_img: docker.io/omnileads/rtpengine:231125.01
    redis_img: docker.io/omnileads/redis:231125.01
```
