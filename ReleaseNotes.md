# Release Notes - OMniLeads 1.33.3
[2024-04-10]

## Added

* oml-2585 [WEB] [API] New endpoint to upload massive contacts from CRM.
* oml-488 [WEB] [ANSIBLE] Now it's possible to deploy an instance with automatically generated Let's Encrypt SSL certificates.

## Improvements

## Fixed

* oml-512 [WEB] Django commands omnileads UID.
* oml-512 [ACD] docker-entrypoint.sh omnileads UID.

## Removed

* oml-463 [ANSIBLE] Now it is possible to migrate to Omnileads Enterprise without inventory.yml flag "enterprise_edition:"

## OMniLeads Component versions

```
    omnileads_img: docker.io/omnileads/omlapp:240410.01
    asterisk_img: docker.io/omnileads/asterisk:240410.01
    fastagi_img: docker.io/omnileads/fastagi:240228.01
    astami_img: docker.io/omnileads/astami:231230.01
    nginx_img: docker.io/omnileads/nginx:240105.01
    websockets_img: docker.io/omnileads/websockets:231125.01
    kamailio_img: docker.io/omnileads/kamailio:231125.01
    rtpengine_img: docker.io/omnileads/rtpengine:231125.01
    redis_img: docker.io/omnileads/redis:231125.01
```
