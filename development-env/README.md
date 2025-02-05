# OMniLeads Docker Compose

El devenv implementa un stack de la App sobre docker-compose.yml que en base a "binds" monta el código fuente de cada repositorio de componente
sobre el contenedor correspondiente a dicho componente. De esta manera el desarrollador podrá trabajar en su entorno local con su editor
de código favorito, pudiendo observar los cambios al mismo tiempo sobre los contenedores operativos en la App.

Ejemplo de service app del docker-compose.yml:

```
volumes:
  - ${REPO_PATH}/omlapp/:/opt/omnileads/ominicontacto/
```

Ejemplo de service acd del docker-compose.yml:

```
volumes:
    - ${REPO_PATH}/omlacd/source/astconf:/etc/asterisk
    - ${REPO_PATH}/omlacd/source/scripts:/opt/asterisk/scripts
```

## Deploy devenv

Se debe contar con docker & docker-compose instalado sobre su sistema operativo (Mac o Linux).

```
git clone https://gitlab.com/omnileads/omldeploytool.git
cd omldeploytool/development-env
```

El deploy del entorno implicará crear un nuevo directorio (omldeploytool/development-env/omnileads-repos) *omnileads-repos* (omldeploytool/development-env/omnileads-repos) 
para allí clonar todos los repositorios de cada componente de OMniLeads.

Para levantar el entorno de desarrollo se deberá ejecutar por única vez el script de deploy.sh

```
$ ./deploy.sh --os_host= --gitlab_clone=
```

Donde os_host puede valer: *linux* o *mac*. Mientras que gitlab_clone *ssh* o *https* a la hora de
elegir por que método se van a clonar los repositorios.

## Reset **admin** password

```
./oml_manage --reset_pass
```

## Inicializar entorno con datos para desarrollo & testing

```
./oml_manage --init_env
```

## Build VueJS

```
./oml_manage --vuejs_install
./oml_manage --vuejs_build
```

## Variables

Todas las variables implicadas en el docker-compose.yml se pueden modificar en el archivo .env

## Build de imagenes

Los servicios: nginx, rtpengine, asterisk, kamailio y app presentan la posibilidad de ser buidleados
desde el compose, por ejemplo:

```
docker-compose build app
```

Además se pueden forzar a que ciertas imagenes se construyan si o si cada vez que se levanta el stack. Para ello se debe modificar el nombre de la img
en el archivo .env, de manera tal que sea una IMG no existente en el container registry. 

Por ejemplo:

```
OMLAPP_IMG=omlapp:dev.1002
```

## Trabajar con Addons

Los Addons permiten adicionar y/o complementar a la aplicación web distribuida como GPLV3. Pueden ser distribuidos tanto utilizando 
licencias open source o restrictivas. 


## Simulate calls from/to PSTN

Adittionally with omnileads container is the pstn-emulator, this an emulation of a PSTN provider,
so you can make calls via Omnileads and have different results of the call based on what you dialed
as well as generate calls from the command line to OMniLeads inbound routes.

##### Dialplan outbound rules:

* Any number dialed finished with 0: PSTN is going to send you a BUSY signal
* Any number dialed finished with 1: PSTN is going to answer your call and playback audios
* Any number dialed finished with 2: PSTN will anwer your call, play short audio then hangup. This will emulate a calle hangup
* Any number dialed finished with 3: PSTN will answer your call after 35 seconds
* Any number dialed finished with 5: PSTN will make you wait 120 seconds and then hangup. This will emulate a NO_ANSWER
* Any number dialed finished with 9: PSTN will simulate a congestion

##### Generate inbound calls to omnileads stack:

```
./oml_manage --call_generate
```

This actions will make an inbound call to the default inbound campaign created from testing data. 
You can attend the call and listen some cool music, then the recordings appear on the recordings search views. 

##### Register your IAX2 softphone to test the stack 

You can register a IAX2 account on pstn-emulator container in order to play with OMniLeads and the softphone you want. 

This are the IAX2 account credentials:

```
username: 1234567
secret: omnileads
domain: localhost
```

Then you can send calls to DID 01177660010 to 01177660015, an also send calls from an agent to this IAX2 account phone calling 1234567.


## Configuring wombat dialer

You only need to do this if you are going to work with Predictive Dialer campaigns

When you enter to http://localhost:8082 or http://hostname-or-ipaddr:8082 you go to Wombat Dialer to begin its configuration. 

