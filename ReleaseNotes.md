# Release Notes - OMniLeads 2.2.0
[2024-10-10]

## Added

- oml-2752 [OMLAPP]: Allow contact creation from the WhatsApp conversation window.
- oml-2730 [OMLAPP]: Manual calls can be restricted by campaign type in group configuration.
- oml-2749 [OMLAPP]: Allow the creation of Group of Hours from the WhatsApp line edit/create window.
- oml-2772 [OMLAPP]: API to get campaign agents and call status.
- oml-2745 [OMLAPP]: New Number field for disposition forms.
- oml-2751 [OMLAPP]: Deactivation of WhatsApp templates.
- oml-2729 [OMLAPP]: Use CRM data for inbound call contact identification.
- oml-2780 [OMLAPP]: Agent ID is sent in the login API response.
- oml-2781 [OMLAPP]: TOKEN_EXPIRED_AFTER_SECONDS can be configured via an environment variable.
- oml-2748 [OMLAPP]: Allow message template creation from the WhatsApp line edit/create window.
- oml-003 [ANSIBLE]: Multi-tenant centralized backup based on Object Storage Bucket.
- oml-575 [ANSIBLE]: Scalability tweaks configurations for Redis & PostgreSQL.

## Improvements

- oml-599 [ANSIBLE]: HA deployment was optimized across all components on two VMs.
- oml-599 [ACD]: Asterisk was upgraded to 20.9.3.
- oml-2784 [OMLAPP]: Line deletion is now allowed for associated lines.
- oml-2732 [OMLAPP] [AGENT-TOOL]: Allow consultative transfer to inbound campaigns.

## Fixes

- oml-633 [OMLAPP]: Web workers UWSGI recycle for scale tuning scenarios.
- oml-2764 [OMLAPP]: Error sending multimedia content via WhatsApp.
- oml-2763 [OMLAPP]: Error creating contact without the 'telefono' field in the contact database.
- oml-614 [OMLAPP]: Error generating Asterisk Music On Hold paths.
- oml-652 [ACD]: Error with Asterisk config generator when the omnileads user UID is different from 1000.

## Component changes

### OMLAPP (Django/VueJS)

- [Container Img](https://hub.docker.com/layers/omnileads/omlapp/241008.01/images/sha256-f7c85491178048906c520bd53ab4ebefd63bd769f01c60f69e47064a16dc23f0?context=explore)
- [Gitlab Repo](https://gitlab.com/omnileads/ominicontacto/-/tree/241009.01?ref_type=tags)

### ACD (Automatic Call Distribution)

- [Container Img](https://hub.docker.com/layers/omnileads/asterisk/240920.01/images/sha256-5da7c2171cf9167ced520a6b735de8290a1190de35ffeafea7b92ab1132dd392?context=explore)
- [Gitlab Repo](https://gitlab.com/omnileads/omlacd/-/tree/241009.01?ref_type=tags)

### FastAGI 

- [Container Img](https://hub.docker.com/layers/omnileads/fastagi/240920.01/images/sha256-dcf86c60d3e7c64abfb9903ad4962614856cde32cb1d1f34ff28d4b4893a0bb1?context=explore)
- [Gitlab Repo](https://gitlab.com/omnileads/omlfastagi/-/tree/241009.01?ref_type=tags)

### Nginx

- [Container Img](https://hub.docker.com/layers/omnileads/nginx/240927.01/images/sha256-8670576b9f4c4fac4cd10c95cbe3b77ea77d53d2a3aede1b56e06e0b5c87c0af?context=explore)
- [Gitlab Repo](https://gitlab.com/omnileads/omlnginx/-/tree/241009.01?ref_type=tags)
