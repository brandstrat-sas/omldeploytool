# OMniLeads Docker Compose

El devenv de OMniLeads plantea un docker-compose.yml que mapea algunos repositorios dentro de algunos contenedores.

Tomamos como ejemplo el código de Django. Donde se puede observar dentro del servicio app, como se mapea el codigo dentro del container.

```
volumes:
  - ${REPO_PATH}/omlapp/:/opt/omnileads/ominicontacto/
```

El deploy del entorno implica que se cree un directorio *omnileads-repos* para allí clonar todos los repos
de los componentes de OMniLeads.

Para levantar el entorno de desarrollo se deberá ejecutar por única vez el script de deploy.sh

```
$ ./deploy.sh --os_host= --gitlab_clone=
```
Donde os_host puede valer: *linux*, *mac* o *win*. Mientras que gitlab_clone *ssh* o *https* a la hora de
elegir por que método se van a clonar los repos.

Además de clonar los repos, el deploy.sh se encarga de setear minIO para que las grabaciones y media_root (django)
operen bajo un bucket provisto por el propio servicio minio.

Finalmente se realiza un pull de todas las imágenes y luego se levanta el entorno.

## Reset django pass

```
./manage.sh --reset_pass
```

## Inicializar entorno con datos de pruebas

```
./manage.sh --init_env
```

## Variables

Todas las variables implicadas en el docker-compose se pueden leer/editar sobre el archivo .env

## Build de imagenes

Los servicios: nginx, rtpengine, acd (asterisk), kamailio y app presentan la posibilidad de ser buidleados
desde el compose, por ejemplo:


```
docker-compose build app
```
