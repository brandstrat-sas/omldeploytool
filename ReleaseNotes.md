# Release Notes - OMniLeads 1.33.1
[2024-01-08]

## Added

* oml-438 [OMLAPP]: Deployment of WhatsApp channel

## Improvements

* oml-438 [DEPLOY]: Now it is possible to deploy OMniLeads with first_boot_installer.sh on Rocky & Alma Linux.
* oml-250 [ASTERISK]: It is now possible to customize certain parameters to achieve scalability of concurrent calls.
* oml-438 [ASTERISK]: Customization of dialplan, AGI, and the Asterisk component environment is now possible using Docker multistage build.
* oml-438 [ANSIBLE]: Within the inventory.yml file, there are various parameters available to customize the scalability of UWSGi and Asterisk.
* oml-50 [NGINX]: The port numbers of each service to which Nginx redirects requests can be passed as environment variables.
* oml-89 [FASTAGI]: The network interface on which the FastAGI service is bound is passed as an environment variable.
* oml-53 [ANSIBLE]: The version number displayed in the "About" web view is now related to the "tag" version of Omnileads Deploy Tool.

## Fixed


## Removed


# OMniLeads Component versions

```
    omnileads_version: 231214-whatsapp.alpha 
    asterisk_version: 240102.01 
    fastagi_version: 240104.01 
    astami_version: 231230.01
    nginx_version: 240105.01 
    websockets_version: 231125.01
    kamailio_version: 231125.01
    rtpengine_version: 231125.01
    redis_version: 231125.01
```
