# Release Notes - OMniLeads 1.33.2
[2024-01-18]

## Added

* Se agrega una columna a la tabla reportes_app_llamadalog con la información de la ruta (entrante o saliente) para cada registro.

## Improvements

* Se añade --rm a los podman run que lanzan las playbooks de backup & django
* Se modifican los scripts de arranque de la app web (django commands)
* Se cambia el orden en el scrip de acciones de failover (aio_transitions.sh)
* Playbook de django para desplegar en HA

## Fixed


## Removed


# OMniLeads Component versions

```
    omnileads_img: docker.io/omnileads/omlapp:240117.01
    asterisk_img: docker.io/omnileads/asterisk:240102.01
    fastagi_img: docker.io/omnileads/fastagi:240104.01
    astami_img: docker.io/omnileads/astami:231230.01
    nginx_img: docker.io/omnileads/nginx:240105.01
    websockets_img: docker.io/omnileads/websockets:231125.01
    kamailio_img: docker.io/omnileads/kamailio:231125.01
    rtpengine_img: docker.io/omnileads/rtpengine:231125.01
    redis_img: docker.io/omnileads/redis:231125.01
```
