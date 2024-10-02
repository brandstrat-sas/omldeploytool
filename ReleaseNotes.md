# Release Notes - OMniLeads 2.2.0

[2024-10-02]

## Added

* oml-003 [ANSIBLE]: Multi tenant centralized backup.
* oml-2729 [OMLAPP]: Fetch parameters (name, surname, etc.) from a REST API based on a call.

## Improvements

* oml-599 [ANSIBLE]: HA deployment was optimized across all components on two VMs.
* Asterisk was upgrade to 20.9.3

## Fixes

* oml-633 [OMLAPP]: Web workers UWSGI recycle for scale tunnings scenay

## Component changes

### OMLAPP (Django/VueJS)

* [Container Img](https://hub.docker.com/)
* [Gitlab Repo](https://gitlab.com/omnileads/)

### ACD (Automatic Call Distribution)

* [Container Img](https://hub.docker.com/)
* [Gitlab Repo](https://gitlab.com/omnileads/omlacd/)

### New OML component ! ACD conf provisioner

* [Container Img](https://hub.docker.com/)
* [Gitlab Repo](https://gitlab.com/omnileads/acd_retrieve_conf/)