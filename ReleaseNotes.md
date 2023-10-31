# Release Notes - OMniLeads 1.32.0
[2023-10-31]

## Added

* oml-2482 - [WEB] Allow any value for Fixed Type (CUSTOM) CRM parameters.
* oml-2484 - [WEB] Control to prevent creating more than one agenda per contact per campaign.
* oml-2517 - [WEB] New endpoint to send HangUp call action via AMI.
* oml-2472 - [WEB] User authentication using LDAP.

## Improvements

* oml-346 - [ANSIBLE] Added the capability to generate an Update.
* oml-346 - [ANSIBLE] Added the capability to generate a Restart for all components.
* oml-384 - [ANSIBLE] Added the capability to set the NAT voip ip address.
* oml-346 - [WEB] The docker-entrypoint.sh script has been divided into several scripts that implement specific commands for each invocation (cron, daphne, uwsgi, migrations, etc.).
* oml-2457 - [WEB] The agent activity logging task has been migrated from asterisk-odbc queue_log to Django.

## Fixed

* oml-2506 - [WEB] JavaScript errors in the address field selection when creating a campaign.
* oml-2499 - [WEB] Positioning fix for elements in the campaign report PDF.

## Removed

* oml-346 - [WEB] All traces of file system logs (django.log and slowsql.log) have been removed.
* oml-389 - [ACD] The connection between Asterisk ODBC and Postgres has been removed, leaving the task of logging to the FastAGI and omalpp components.

# OMniLeads Component versions

```
    omnileads_version: 231030.01
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
