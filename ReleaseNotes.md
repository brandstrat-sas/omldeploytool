# Release Notes - OMniLeads 2.1.0

[2024-08-02]

## Added

* oml-2668 [OMLAPP] Audio File creation using TTS Services
* oml-2675 [OMLAPP] Whatsapp multimedia mesagges

## Improvements

* oml-589 [ACD] Upgrade Asterisk 20.9.1.
* oml-589 [ACD] The asterisk_reloader script, which generates the business logic configuration, now runs in a separate container.
* oml-2723 [OMLAPP] Allow ignoring SSL validation in External Site Authentication requests

## Fixes

* oml-2728 [OMLAPP] Fix error on Whatsapp conversation initialization
* oml-xxx [ACD] Fix consultative transfer call recording

## Component changes

### OMLAPP (Django/VueJS)

* [Container Img](https://hub.docker.com/layers/omnileads/omlapp/240802.01/images/sha256-beed8eeaa49494defa30e6f1a224d74aabaf50d7a736f73edd51e25a0264933a?context=explore)
* [Gitlab Repo](https://gitlab.com/omnileads/ominicontacto/-/tree/240802.01?ref_type=tags)

### ACD (Automatic Call Distribution)

* [Container Img](https://hub.docker.com/layers/omnileads/asterisk/240728.01/images/sha256-1878c24e0de58698b77e47038ef699ecf25b23a403f7ce58c5ecb6b76282d2bf?context=explore)
* [Gitlab Repo](https://gitlab.com/omnileads/omlacd/-/tree/240728.01?ref_type=tags)

### New OML component ! ACD conf provisioner

* [Container Img](https://hub.docker.com/layers/omnileads/acd_retrieve_conf/240729.01/images/sha256-60e8250411697c5b384dc1015a6302c06665f120726b8455090ad3e11ef8e161?context=explore)
* [Gitlab Repo](https://gitlab.com/omnileads/acd_retrieve_conf/-/tree/240729.01?ref_type=tags)