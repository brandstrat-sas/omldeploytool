# Release Notes - OMniLeads 1.31.0
[2023-10-09]

## Added

* oml-304 - [AMI] New component ASTAMI in order to interact with Asterisk AMI
* oml-304 - [FastAGI] Daily statistics on agents and campaigns in Redis Hash for real-time views
* oml-328 - [ACD] Now it's possible to have OML ACD on a network and Wombat Dialer in another network segment or external network
* oml-2460 - [WEB] It is now possible to know the Agent Status in Transfers between peers 
* oml-2430 - [WEB] VoIP Trunk Status can be viewed directly from the trunk view. 
* oml-2461 - [WEB] New functionality to clone agents from skills and group permissions 
* oml-2462 - [WEB] It is now possible to view the previous management data of a contact in incoming messages, and know the agent who received your attention 

## Improvments

* oml-304 - [ANSIBLE] setting high performance uwsgi.ini
* oml-345 - [ANSIBLE] send container logs from stdout/sterror to journald
* oml-2479 - [WEB] Aesthetic improvement in call transfer form 
* oml-2476 - [WEB] Cosmetic improvements to agent dashboard - rating history

## Fixed

* oml-2478 - [WEB] fix in Transfers to Campaigns against IDs cached incorrectly 
* oml-2471 - [WEB] fix in report generation 
* oml-355 - [RTPEngine] RTPengine scenary for NAT onpremise deploys
* oml-35 - [KAM] kamailio fix antiflood inboubd calls 
* oml-310 - [ACD] There is default Music On Hold (MOH) available for inbound campaigns

## Removed

* oml-345 - [ALL] All types of containers file logging have been removed

# OMniLeads Component versions

```
    omnileads_version: 230928.01
    asterisk_version: 231006.01
    fastagi_version: 230920.01
    astami_version: 230920.01
    nginx_version: 230923.01
    websockets_version: 230204.01
    kamailio_version: 230925.01
    rtpengine_version: 230925.01
    redis_version: 230704.01
    postgres_version: 230624.01
```
