# Release Notes - OMniLeads 2.0.2

[2024-07-05]

## Added

* oml-2700 Agents to transder ordered by Ready state
* oml-2674 Whatsapp conversations can be exported to .csv file

## Improvements

* oml-2701 Event Audit allows filtering by day
* oml-2703 New Outbound Routes regex for special characters
* oml-2708 Several reports button blocked on click to prevent server overload
* oml-2162 Tests optimization

## Fixes

* oml-571 [NGINX]: Download call recording pool as zip
* oml-2717 [WEBSOCKETS]: Websockets interrupt execution due to an exception
* oml-567 [NGINX]: Download PDF reports
* oml-570 [ANSIBLE]: django.env template and CORS_ORIGIN inventory variable
* oml-2669 [OMLAPP]: Inconsistent agents activity logging
* oml-2569 [OMLAPP]: Previous day data showing in Inbound calls Supervision

## OMniLeads Component versions

```
    omnileads_img: docker.io/omnileads/omlapp:240705.01
    asterisk_img: docker.io/omnileads/asterisk:240503.01
```