# Release Notes - OMniLeads 1.31.0
[2023-10-19]

## Added

## Improvments

* oml-346 - [WEB][ANSIBLE] Se añade la posibilidad de generar un Update
* oml-346 - [WEB][ANSIBLE] Se añade la posibilidad de generar un Restart de todos los componentes
* oml-346 - [WEB] Se dividió el script docker-entrypoint por varios scripts que implementan comandos especificos para cada invocación (cron, daphne, uwsgi, migrations, etc.)

## Fixed

* .....

## Removed

* oml-346 - [WEB] Se remueve todo vestigio de logs sobre archivos del filesystem (django.log y slowsql.log)
* oml-389 - [ACD] Se remueve la conexión entre asterisk odbc y postgres dejando la tarea de registrar logs a los componentes fastagi y omalpp

# OMniLeads Component versions

```
    omnileads_version: 231005.01
    asterisk_version: 230925.02
    fastagi_version: 230920.01
    astami_version: 230920.01
    nginx_version: 230923.01
    websockets_version: 230204.01
    kamailio_version: 230925.01
    rtpengine_version: 230925.01
    redis_version: 230704.01
    postgres_version: 230624.01
```
