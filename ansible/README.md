## Gestion de OMniLeads basada en Ansible

Este formato de gestión se abarca instalaciones de nuevas instancias, manejo de actualizaciones y procedimientos de backups & restore,
utilizando un único script y archivo de configuración, invocado con diferentes flags dependiendo de la acción a concretar sobre la
instancia en cuestión.

................

La gestión se realiza desde la estación de trabajo del sysadmin a parir de dos archivos; deploy.sh e inventory.
El primero es a quien se invoca para disparar la acción en concreto (deploy, upgrade, backup, etc.), el segundo
sirve para ajustar parámetros de configuración a ser implementados sobre la instancia a aplicar el despliegue.

# Ansible + Inventory

El archivo de inventario es la fuente de configuración de la instancia sobre la cual se va a trabajar.
Allí se ajustan parámetros como las versiones de las imágenes de cada componente o cuestiones de configuración
de base de datos (usuarios, passwords, etc.)

Respecto a este archivo, vamos a repasar los parámetros principales, es decir los que si o si debo
ajustar para lograr una instalación exitosa.

Antes que nada en la seccion [omnileads-app], debemos ingresar el host o listado de hosts sobre los cuales deseamos
instalar OMniLeads.


```
[omnileads-app]

algarrobo ansible_host=147.182.235.93 ansible_ssh_port=22 omni_ip_lan=10.10.1.2 omni_ip_wan=147.182.235.93 infra_env=cloud
qubracho ansible_host=147.182.323.11 ansible_ssh_port=22 omni_ip_lan=172.16.10.2 omni_ip_wan=147.182.323.11 infra_env=cloud
moye ansible_host=147.182.223.12 ansible_ssh_port=22 omni_ip_lan=192.168.10.12 omni_ip_wan=147.182.223.12 infra_env=lan
```

Cada entrada correspondiente a cada instancia de OMniLeads debe contar con los siguientes parámetros:

* nombre de referencia: se declara el nombre con el que Ansible hara referencia a la instancia
* ansible_host: la dirección IP o fqdn para acceder al host desde el nodo ansible
* ansible_ssh_port: el puerto SSH para acceder al host desde el nodo ansible
* omni_ip_lan: la dirección IP local de la instancia
* omni_ip_wan: la dirección IP WAN de la instancia o bien con la que sale a internet (NAT)
* infra_env: el tipo de infraestructura sobre la cual se va a desplegar la App; lan, cloud o hybrid.

Luego tenemos la sección [everyone:vars], en donde se van a ajustar variables de OMniLeads en general.
Sin embargo vamos a poner énfasis en la sección de versionado de componentes.

Cada componente tiene asociado una version de imagen de contenedor.

```
################################################################################
# ********** Below are the img versions used for OMniLeads deploy ************ #
# ********** Below are the img versions used for OMniLeads deploy ************ #
################################################################################

django_version=djangovue
websockets_version=latest
nginx_version=latest
kamailio_version=latest
asterisk_version=latest
rtpengine_version=latest
```

Luego se debe ajustar la zona horaria. Vamos a ignorar por ahora los parámetros referidos a los _host de cada componente.

```
################################################################################
# ****************** Network location - OMniLeads components  **************** #
# ****************** Network location - OMniLeads components  **************** #
################################################################################

# --- Set the timezone
TZ=America/Argentina/Cordoba

#application_host=
#voice_host=
#postgres_host=
```

El resto de los parámetros son sencillos de asimilar y cuentan con su descripción
dentro del mismo archivo.

# Bash Script deploy.sh

Este script recibe parámetros que comandan la acción a efectuar, esta acción tiene que ver con invocar a la Playbook
matrix.yml quien a partir del archivo de inventario previamente editado terminara desplegando la acción en concreto sobre la instancia o grupo de instancias.

```
$ ./deploy.sh --help

```

A la hora de una instalacion o actualizacion se deben enviar dos parametros:

* --action=
* --component=

El nombre del componente puede ser

## Deploy de nueva instancia - All in One

Como primer paso se debe editar el archivo de inventario de acuerdo a las personalizaciones que se deseen implementar, para luego invocar el script de deploy.sh.

Aqui simplemente tener en cuenta que si la instancia va a ser accedida solamente desde la LAN, entonces el inventory tendra este aspecto:

```
[omnileads-app]
omnileads ansible_host=147.182.235.93 ansible_ssh_port=22 ansible_user=root omni_ip_lan=10.10.10.2 omni_ip_wan=147.182.235.93 infra_env=lan
```

Mientras que si la instancia se hostea en la nube para ser accedida desde internet:

```
[omnileads-app]
omnileads ansible_host=147.182.235.93 ansible_ssh_port=22 ansible_user=root omni_ip_lan=10.10.10.2 omni_ip_wan=147.182.235.93 infra_env=cloud
```

Es decir, lo unico que cambio es la variable "infra_env", en la linea declaratoria de la instancia a desplegar. Luego simplemente se debe ejecutar el deploy.sh.

```
./deploy.sh --action=install --component=aio

```

## Deploy instancia con Backing como servicio administrado del Cloud

En este formato se asumo que PostgreSQL y Object Storage DB seran proporcionados por el proveeedor cloud seleccionado. Esto implica que
esos dos servicios en lugar de desplegarlos nosotros, simplemente debemos informar en el archivo de inventory sus datos de conexion.

De esta manera OMniLeads va a almacenar los datos relacionales (SQL) y las grabaciones & backups sobre (Object Storage) del cloud, obviando
la instalacion de ambos componentes dentro de la instancia Linux donde corre OMniLeads.

Vamos a plantear un inventory de referencia, en donde se supone que el cloud provider nos brinda los datos de conexion a Postgres. Observar que lo primero a hacer es descomentar postgres_host y asignarle el string de conexion correspondiente.

Luego simplemente se trata de ajustar los demas parametros de conexion, de acuerdo a si vamos
a necesitar establecer una conexion SSL, poner el postgres_cloud=yes para que se cree plperl y si el servicio de PostgreSQL implica un cluster con mas de un nodo, entonces se puede activar mediante
postgres_ha=true y postgres_ro_host=X.X.X.X para indicar que las queries se impacten sobre el nodo de replica del cluster.

```
postgres_host=string_de_conexion_pgsql_cloud_provider

postgres_port=5432
postgres_user=omnileads
postgres_password=AVNS_m0GH-Fk0ZXWWOxNWdSY
postgres_database=omnileads

# ----  to activate ssl on asterisk odbc.ini (some cloud providers imply SSL)
postgres_ssl=false
# ----  to create plperl extension
postgres_cloud=false

# ----  to activate HA deploy set "true"
postgres_ha=false
# ----  RO (Read Only) postgres node IP/HOSTNAME
postgres_ro_host=
```

Con respecto a Object Storage, simplemente se debe descomentar bucket_url y asignarle el valor correspondiente al cloud indicado. Tambien los parametros de autenticacion deberan ser proporcionados. Respecto al bucket_region en caso de no necesitar especificar nada, se debe dejarlo
con el valor actual.

```
# --- if you want to use cloud provider bucket, must uncomment & set this:
bucket_url=https://ewr1.vultrobjects.com

bucket_access_key=dsadsadsad
bucket_secret_key=BNVBNbnvghfhg76574632ghfgh
bucket_name=omnileads
bucket_region=us-east-1
```

Finalmente se lanza el deploy:

```
./deploy.sh --action=install --component=aio

```

## Deploy de actualizaciones


## Deploy de backup


## Deploy de disaster recovery
