# Release Notes - OMniLeads 2.0.2

[2024-07-13]

## Added

* oml-2700 [OMLAPP]: Agents to transder ordered by Ready state
* oml-2674 [OMLAPP]: Whatsapp conversations can be exported to .csv file

## Improvements

* oml-2701 [OMLAPP]: Event Audit allows filtering by day
* oml-2703 [OMLAPP]: New Outbound Routes regex for special characters
* oml-2708 [OMLAPP]: Several reports button blocked on click to prevent server overload
* oml-2162 [OMLAPP]: Tests optimization

## Fixes

* oml-570 [ANSIBLE]: django.env template and CORS_ORIGIN inventory variable
* oml-2444 [NGINX]: Download PDF reports
* oml-571 [OMLAPP]: Download call recording pool as zip
* oml-2717 [WEBSOCKETS]: Websockets interrupt execution due to an exception
* oml-2669 [OMLAPP]: Inconsistent agents activity logging
* oml-2569 [OMLAPP]: Previous day data showing in Inbound calls Supervision
* oml-2222 [OMLAPP]: Fix External Site Json Authentication

## Component changes

### omlapp (Django/VueJS)

* [Container Img](https://hub.docker.com/layers/omnileads/omlapp/240712.01/images/sha256-19ec611afa23e3fbe05eeab31dd49cfd84e2e2684c04ce482e6780dee400d7cb?context=explore)
* [Gitlab Repo](https://gitlab.com/omnileads/ominicontacto/-/blob/2407012.01/)

### nginx

* [Container Img](https://hub.docker.com/layers/omnileads/nginx/240705.01/images/sha256-2ec0242101b379315e65d21ac05ba37e8ae43e25f98f21d779d362dbe3fee2c5?context=explore)
* [Gitlab Repo](https://gitlab.com/omnileads/omlnginx/-/blob/240705.01/)

### websockets

* [Container Img](https://hub.docker.com/layers/omnileads/websockets/240705.01/images/sha256-f6dacc875148dbf8b2ae4156ce28d677ebc70d85520adf4db49c1d6e80010c95?context=explore)
* [Gitlab Repo](https://gitlab.com/omnileads/omnileads-websockets/-/tree/240705.01?ref_type=tags)