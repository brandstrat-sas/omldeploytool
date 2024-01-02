# Release Notes - OMniLeads Beta 2.0.0
[2023-12-23]

## Added

* oml-438 [OMLAPP]: Deployment of WhatsApp channel

## Improvements

* oml-438 [DEPLOY]: Now it is possible to deploy OMniLeads with first_boot_installer.sh on Rocky & Alma Linux.
* oml-250 [ASTERISK]: It is now possible to customize certain parameters to achieve scalability of concurrent calls.
* oml-438 [ASTERISK]: Customization of dialplan, AGI, and the Asterisk component environment is now possible using Docker multistage build.
* oml-438 [ANSIBLE]: Within the inventory.yml file, there are various parameters available to customize the scalability of UWSGi and Asterisk.

## Fixed


## Removed


# OMniLeads Component versions

```
    omnileads_version: 231214-whatsapp.alpha (freetechsolutions)
    asterisk_version: 240102.01 (freetechsolutions)
    fastagi_version: 231207.01
    astami_version: 231125.01
    nginx_version: 231125.01
    websockets_version: 231125.01
    kamailio_version: 231125.01
    rtpengine_version: 231125.01
    redis_version: 231125.01
```
