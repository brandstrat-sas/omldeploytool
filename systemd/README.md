#### This project is part of OMniLeads

![Diagrama deploy tool](./png/omnileads_logo_1.png)

#### 100% Open-Source Contact Center Software
#### [Community Forum](https://forum.omnileads.net/)

---

## Ansible System-D based OMniLeads management

In this repository you will find an alternative to implement OMniLeads tenant management from an on-premise
IT management perspective, but also completely viable for working in cloud-computing environments.

The idea is to be able to manage several OMniLeads tenants from this ansible based management tool.

This option covers everything, from installing new instances, managing updates to executing backup & restore procedures,
all that using a single script and configuration file.


![Diagrama deploy tool](./png/deploy-tool-ansible-deploy-instances-multiples.png)


## Index

* [Bash, Ansible & System D](#bash-ansible-systemd)
* [Ansible + Inventory](#ansible-inventory)
* [Bash Script deploy.sh](#bash-script-deploy)
* [Subscriber tracking & TLS certs](#subscriber-traking)
* [Deploy LAN instance with self-hosted backend (Postgres & Object Storage)](#onpremise-deploy)
* [Deploy Cloud instance with backend (Postgres y Object Storage) as cloud service](#cloud-deploy)
* [Deploy High Availability OMniLeads on premise instance](#onpremise-deploy)
* [TLS Certs provisioning](#tls-cert-provisioning)
* [Deploy an upgrade](#upgrades)
* [Deploy a rollback](#rollback)
* [Deploy a backup](#backups)
* [Deploy a restore](#restore)
* [Deploy an upgrade from CentOS7](#upgrade_from_centos7)
* [Observability](#observability)


## Bash, Ansible & System D 📋 <a name="bash-ansible-systemd"></a>

The management of multiple instances is done from the administrator's workstation. When preparing a new deployment
there are three fundamental files that are invoked in a chain, which help to understand how the management is planned
of the tenants, these are:

* **deploy.sh**: launch the root ansible playbook invoking the inventory file corresponding to the tenant that you want to manage.
* **inventory.yml**: configuration parameters of the OMniLeads instance to be deployed.
* **matrix.yml**: the ansible root playbook

Each instance of OMniLeads is generated on three Linux instances (application, voice, and data).
In other words, we are going to have a Linux instance dedicated to executing the containers corresponding to the Application stack, 
on the second the containers of the voice processing stack are executed and on the third those of the data stack.

![Diagrama deploy tool](./png/deploy-tool-tenant-a.png)

Then, once OMnileads is deployed on the corresponding instances, each container on which a component works
can be managed as a systemd service.

```
systemd start component
systemd restart component
systemd stop component
```

![Diagrama deploy tool zoom](./png/deploy-tool-ansible-deploy-instances.png)

## Ansible + Inventory 🔧 <a name="ansible-inventory"></a>

The inventory file is the configuration source of the instance on which you are going to work.
Parameters such as the component image version or configuration issues are adjusted there
database (users, passwords, etc.).

Regarding this file, we are going to review the main parameters, that is, those that do or should I
adjust for a successful installation.

We start with the data to provide about the three necessary linux instances, there we must
load the IP addresses corresponding to each linux instance so that Ansible can set the
connection, in addition to providing the LAN IP address of each instance.

So on the one hand we have the *ansible_host* parameter that implies the IP address over which
the SSH connection must be established by Ansible, while the *omni_ip_lan* parameter does
reference to a private address on which OMniLeads raises some services and uses
to communicate between the three instances. It may happen that both are worth the same (especially
in a deployment scenario over LAN or VPN)

```
all:
  hosts:
    omnileads_data:
      omldata: true
      ansible_host: 172.16.101.41
      omni_ip_lan: 172.16.101.41
      ansible_ssh_port: 22      
    omnileads_voice:
      omlvoice: true
      ansible_host: 172.16.101.42
      omni_ip_lan: 172.16.101.42
      ansible_ssh_port: 22      
    omnileads_app:
      omlapp: true
      ansible_host: 172.16.101.43
      omni_ip_lan: 172.16.101.43
      ansible_ssh_port: 22   
```

Then we count the tenant variables to display, labeled/indented under *vars:*. Here we find
all the adjustable parameters when invoking a deploy on a group of instances. each one is
described by a *# --- comment* preceding it.

```
vars:
    # --- ansible user auth connection
    ansible_user: root
    # --- Activate the OMniLeads Enterprise Edition - with "AAAA" licensed.
    # --- on the contrary you will deploy OMniLeads OSS Edition with GPLV3 licensed. 
    enterprise_edition: true
    # --- versions of each image to deploy
    # --- versions of each image to deploy
    omnileads_version: 1.26.0
    websockets_version: 230204.01
    nginx_version: 230215.01
    kamailio_version: 230204.01
    asterisk_version: 230204.01
    rtpengine_version: 230204.01
    postgres_version: 230204.01    
    # --- "cloud" instance (access through public IP)
    # --- or "lan" instance (access through private IP)
    # --- in order to set NAT or Publica ADDR for RTP voice packages
    infra_env: cloud
    # --- If you have an DNS FQDN resolution, you must to uncomment and set this param
    # --- otherwise leave commented to work invoking through an IP address
    #fqdn: fidelio.sephir.tech

```

## Bash Script deploy.sh 📄 <a name="bash-script-deploy"></a>

This script receives parameters that command the action to be carried out, this action has to do with invoking the Playbook
matrix.yml who, from the previously edited inventory file, will end up deploying the specific action on the app and voice instances.

```
./deploy.sh --help

```

To run an installation or updates deployment, two parameters must be called.

* **--action=**
* **--tenant=**

```
./deploy.sh --action=install --tenant=tenant_name_folder

```

## Certs and inventory tenant folder :office: <a name="subscriber-traking"></a>

In order to manage multiple instances of OMniLeads from this deployment tool, you must create
a folder called **instances** at the root of this directory. The reserved name for this folder is
**instances** since said string is inside the .gitignore of the repository.

The idea is that the mentioned folder works as a separate GIT repository, thus providing the possibility
to maintain an integral backup in turn that the SRE or systems department is supported in the use of GIT.

```
git clone your_tenants_config_repo instances
```

Then, for each *instance* to be managed, a sub-folder must be created within instances.
For example:

```
instances/Subscriber_A
```

Once the tenant folder is generated, there you will need to place a copy of the *inventory.yml* file available
in the root of this repository, in order to customize and tack inside the private GIT repository.

```
cp inventory.yml instances/Subscriber_A
git add instances/Subscriber_A
git commit 'my new Subscriber A'
git push origin main
```

## Deploy a new LAN instance with Backend (Postgres and Object Storage) self-hosted 🚀 <a name="onpremise-deploy"></a>

You must have two Linux instances (Ubuntu 22.04, Debian 11, Rocky 8 or Alma Linux 8) with Internet access and **your public key (ssh) available**, since
ansible needs to establish an SSH connection through public key.

![Diagrama deploy](./png/deploy-tool-tenant.png)

Then you should work on the inventory.yml file

Regarding addresses and connections. The parameter *omni_ip_lan* refers to the private IP (LAN) that will be used when opening certain ports for components, as well as when they connect with each other.

```
all:
  hosts:
    omnileads_data:
      omldata: true
      ansible_host: 10.10.10.2 
      omni_ip_lan: 10.10.10.2
      ansible_ssh_port: 22      
    omnileads_voice: 
      omlvoice: true
      ansible_host: 10.10.10.3
      omni_ip_lan: 10.10.10.3
      ansible_ssh_port: 22      
    omnileads_app:
      omlapp: true
      ansible_host: 10.10.10.4
      omni_ip_lan: 10.10.10.4
      ansible_ssh_port: 22  
```

The infra_env parameter should be initialized as 'lan'.

```
infra_env: lan
```

And finally, the *bucket_url* and *postgres_host* parameters must be commented out, so that both (PostgreSQL and Object Storage MinIO) are deployed within the data instance.

The rest of the parameters can be customized as desired.

Finally, the deploy.sh should be executed.

```
./deploy.sh --action=install --tenant=tenant_name_folder
```

## Deploy a new instance with Backend (Postgres and Object Storage) as a managed Cloud service 🚀 <a name="cloud-deploy"></a>

You must have three Linux instances (Debian 11 or Rocky 8) with Internet access and **your public key (ssh) available**, since
Ansible needs to establish an SSH connection to deploy the actions.

Also under this format it is assumed that PostgreSQL and S3-compatible Object Storage are going to be provided as managed services by the selected cloud provider. This implies that these two OMniLeads components will not be deployed on the data instance as in the previous case.

![Diagrama deploy cloud services](./png/deploy-tool-tenant-cloud-services.png)

We are going to propose a reference inventory, where the cloud provider is supposed to give us the connection data to Postgres.
The parameter *postgres_host* must be assigned the corresponding connection string.
Then it is simply a matter of adjusting the other connection parameters, according to whether we are going to need to establish an SSL connection, set the *postgres_ssl: true*.
If the PostgreSQL service involves a cluster with more than one node, then it can be activated by *postgres_ha: true* and *postgres_ro_host: X.X.X.X*
to indicate that the queries are impacted on the cluster replica node.

Regarding storage over Object Storage, the URL must be provided in *bucket_url*.
Also the authentication parameters must be provided; *bucket_access_key* & *bucket_secret_key* as well as the *bucket_name*.
Regarding the bucket_region, if you do not need to specify anything, you should leave it with the current value.

Finally the deploy is launched:

```
./deploy.sh --action=install --tenant=tenant_name_folder
```

## Deploy High Availability onpremise instance 🚀 <a name="cloud-deploy"></a>


Se dispone de un archivo de inventario capaz de materializar un cluster de alta disponibilidad sobre 2 servidores físicos. 
El cluster es basicamente una replicación (en Standby) de los componente de OMniLeads.

![Diagrama deploy cloud services](./png/HA_box_deploy.png)

Hilando más fino el cluster puede ser visto en catro partes (o 4 miniclusters).

* Data
* Voice
* App
* Load Balancer

En este formato de deploy, OMniLeads necesita de una etapa de balanceo de carga para que recepcione las solicitudes Web.
y las distribuya bajo algún algoritmo sobre las dos instancias (una VM sobre cada nodo hypervisor) de aplicación que son ejecutadas.

Se debe disponer de 8 Maquinas virtuales siendo las mismas distribuidas bajo el siguiente esquema:

* **Hypervisor A:** App + Redis Main, Postgres Main, Voice Backup
* **Hypervisor B:** App + Redis Backup, Postgres Backup, Voice Main

![Diagrama deploy cloud services](./png/HA_box.png)


* Redis: se utiliza Sentinel, que es el director del cluster. Quien promociona en base a una logica el rol de cada Redis.
* Postgres: se utiliza repmgr, que es el directori del cluster. Quien promociona en base a una logica el rol de cada Postgres.
* Asterisk: se utiliza Keepalived con el fin de supervisar al nodo activo y en caso de una caída del mismo, levantar la IP Virtual (VIP) sobre el nodo de Failover.
* HAProxy: se utiliza Keepalived con el fin de supervisar al nodo activo y en caso de una caída del mismo, levantar la IP Virtual (VIP) sobre el nodo de Failover.
* Aplicación Web: estos nodos corren como Activo-Activo, es decir hay dos instancias de App corriendo y que atienden peticiones en base al balanceo que en una etapa anterior, lleva a cabo Haproxy. 

Manos a la obra !

Para desplegar nuestro cluster debemos contar con 2 VM con CentOS7 (para el cluster de Postgres) por un lado y 6 VM con Debian11 (o ubuntu-22.04 o rocky linux 8) para confeccionar los clusters de App, Voice y Load balancer. 

Supongamos la siguiente distribución de componentes sobre las VM y configuración de IPs:

```
VM data RW: 172.16.101.101 (Hypervisor A)
VM data RO: 172.16.101.102 (Hypervisor B)
VM voice main: 172.16.101.103 (Hypervisor B)
VM voice backup: 172.16.101.104 (Hypervisor A)
VM app+redis main: 172.16.101.105 (Hypervisor A)
VM app+redis backup: 172.16.101.106 (Hypervisor B)
VM haproxy main: 172.16.101.107 (Hypervisor B)
VM haproxy backup: 172.16.101.108 (Hypervisor A)

VIP postgres RW: 172.16.101.201
VIP postgres RO: 172.16.101.202
VIP voice_host: 172.16.101.203
VIP haproxy_host: 172.16.101.204
```

Es necesario contar con el acceso a un bucket Object Storage externo. Es decir que la instalación de OMniLeads
en HA no contempla por ahora el deploy de MinIO Object Storage, por lo que es necesario para continuar con un despliegue 
de la App en alta disponibilidad que se cuente con el bucket y sus claves de acceso.

Entonces como ejemplo seguiremos con las IPs planteadas a la hora de plantear el archivo de inventory.

```
---
############################################
omnileads_data:
  hosts:
    sql_1:  
      ansible_host: 172.16.101.101      
      omni_ip_lan: 172.16.101.101
      ansible_ssh_port: 22
      ha_rol: main
    sql_2:  
      ansible_host: 172.16.101.102
      omni_ip_lan: 172.16.101.102
      ansible_ssh_port: 22  
      ha_rol: backup
  vars:
    postgres_host_ha: true
    ha_vip_nic: eth0
    netaddr: 172.16.101.0/16
    netprefix: 24
############################################
omnileads_voice:
  hosts:
    voice_1:  
      ansible_host: 172.16.101.103
      omni_ip_lan: 172.16.101.103
      ansible_ssh_port: 22
      ha_rol: main
    voice_2:
      ansible_host: 172.16.101.104
      omni_ip_lan: 172.16.101.104
      ansible_ssh_port: 22
      ha_rol: backup
  vars:
    omlvoice: true
    ha_vip_nic: ens18    
############################################
omnileads_haproxy:
  hosts:
    haproxy_1:
      ansible_host: 172.16.101.108
      omni_ip_lan: 172.16.101.108
      ansible_ssh_port: 22
      ha_rol: main
    haproxy_2:  
      ansible_host: 172.16.101.109
      omni_ip_lan: 172.16.101.109
      ansible_ssh_port: 22  
      ha_rol: backup
  vars:
    omlhaproxy: true
    ha_vip_nic: ens18
    app_port: 443
############################################
omnileads_app:
  hosts:
    app_1:  
      ansible_host: 172.16.101.105
      ansible_ssh_port: 22
      omni_ip_lan: 172.16.101.105
      ha_rol: main
    app_2:
      ansible_host: 172.16.101.106
      ansible_ssh_port: 22
      omni_ip_lan: 172.16.101.106
      ha_rol: backup
  vars:
    ha_vip_nic: ens18
    omlapp: true
############################################

all: 
  vars:
    # --- ansible user auth connection
    ansible_user: root

    # -- Cluster Redis IP (Haproxy VIP)
    redis_host: 172.16.101.204
    # --  Cluster redis Main node
    redis_ip_main: 172.16.101.104
    # --  Cluster postgres RW IP
    postgres_host: 172.16.101.201
    # --  Cluster postgres RO IP
    postgres_ro_host: 172.16.101.201
    # --  Cluster Voice (Asterisk + RTPengine) IP
    voice_host: 172.16.101.203
    # -- Cluster HTTP Web App (HAProxy VIP)
    application_host: 172.16.101.204
    # -- Cluster public NAT IP
    omni_ip_wan: 190.19.150.8

    kamailio_version: 230204.01
    asterisk_version: 230328.01
    rtpengine_version: 230204.01
    omnileads_version: 1.26.0
    websockets_version: 230204.01
    nginx_version: 230215.01
    postgres_version: 230204.01
    centos_postgresql_version: 11

    # --- Activate the OMniLeads Enterprise Edition - with "AAAA" licensed.
    # --- on the contrary you will deploy OMniLeads OSS Edition with GPLV3 licensed. 
    enterprise_edition: true
    omnileads_ha: true
    ha_notification_email: fabian.pignataro@freetechsolutions.com.ar

    # -- Cluster public NAT IP
    omni_ip_wan: 190.19.150.8
    # --  Cluster redis IP
    # --  Use in case of run RTPEngine out of this deploy
    # rtpengine_host: 172.16.101.203
    # -- Dialer host
    # dialer_host: 10.10.10.10
    # -- Bucket URL for Django & Asterisk
    bucket_url: https://172.16.101.3:9000
    # --- ansible user auth connection
    ansible_user: root
    # --- version of each image to deploy
    # --- "cloud" instance (access through public IP)
    # --- or "lan" instance (access through private IP)
    # --- in order to set NAT or Publica ADDR for RTP voice packages
    infra_env: lan
    # --- If you have an DNS FQDN resolution, you must to uncomment and set this param
    # --- otherwise leave commented to work invoking through an IP address
    #fqdn: fabis.sefirot.cloud
    ...
    ...
    ...
    ...
```

Recordemos que todas las VM deben poseer la clave ssh de nuestro deployer (ssh-copy-id root@....). 

Una vez ajustado el archivo de inventario, se ejecuta el script de deploy.sh.

```
./deploy.sh --action=install --tenant=tenant_name_folder
```

La disposicion de los componentes contempla la ejecucion tanto del nodo RW de postgres y redis sobre el hypervisor A, 
mientras que el nodo activo de Asterisk y Haproxy sobre el hypervisor B.

![Diagrama deploy](./png/HA_hypervisors_and_vm.png)

Por lo tanto tenemos un failover si llega a caer el Hypervisor-A entonces los componentes Postgres-RW y Redis-RW hacen un failover
sobre el Hypervisor-B. Mientras que si cae el Hypervisor-B los componentes Haproxy-activo y Asterisk-activo ejecutan 
un failover sobre el Hypervisor-A.

### Recovery Postgres main node

Cuando se produce un Failove desde Postgres Main sobre Postgres Backup entonces el nodo Backup toma la IP flotante del cluster y queda 
como unico nodo RW/RO con sus IPs correspondientes. 

Para volver Postgres al estado inicial se deben llevar a cabo dos acciones:

```
./deploy.sh --action=pgsql_node_recovery_backup --tenant=tenant_name_folder
```

Este comando se encarga de volver a unir el nodo Postgres Main al cluster. Pero si solo ejecutamos esta acción entonces 
el Cluster quedará invertido, es decir Postgres B como main y Postgres A como backup.

### Takeover Postgres main node


Este comando implica que antes se haya ejecutado un Recovery como se expone en el paso anterior. 

```
./deploy.sh --action=pgsql_node_takeover_main --tenant=tenant_name_folder
```

Luego de la ejecución del takeover tendremos el cluster en el estado inicial, es decir Postgres A como Main y Postgres B como backup.

### Takeover Redis main node


Una ultima accion a concretar tiene que ver con el takeover del nodo Redis, de manera tal que dejemos el cluster de Redis en el estado inicial, 
es decir Redis A como main y Redis B como backup.

```
./deploy.sh --action=redis_node_takeover_main --tenant=tenant_name_folder
```


## TLS/SSL certs provisioning :closed_lock_with_key: <a name="tls-cert-provisioning"></a>


From the inventory variable *certs* you can indicate what to do with the SSL certificates.
The possible options are:

* **selfsigned**: which will display the self-signed certificates (not recommended for production).
* **custom**: if the idea is to implement your own certificates. Then you must place them inside instances/tenant_name_folder/ with the names: *cert.pem* for and *key.pem*
* **certbot**: comign soon ...


## Post-installation steps :beer:


Once the URL is available with the App returning the login view,  we can log in with the user *admin*, password *admin*.

It is also possible to generate a test environment by calling:

```
oml_manage.sh --init_env
```

Where some users, routes, trunks, forms, breaks, etc. are generated.

From then on we can log in with the agent type user *agent*, password *agent1**.


## Perform a Backup :floppy_disk: <a name="backups"></a>


Deploying a backup involves the asterisk custom configuration files /etc/asterisk/custom on the one hand and the database
on the other, using the bucket associated with the instance as a backup log.

To launch a backup, simply call the deploy.sh script:

```
./deploy.sh --action=backup --tenant=tenant_name_folder
```

El backup lo deposita en el bucket, quedando bajo la carpeta backup por un lado un archivo .sql con el timestamp y por otro lado
se genera otro directorio con la fecha timestamp y alli dentro van los archivos custom y override de asterisk.


FOTO

## Upgrades :arrows_counterclockwise:  <a name="upgrades"></a>

The OMniLeads project builds images of all its components to be hosted in docker hub: https://hub.docker.com/repositories/omnileads.

We are going to differentiate the web application repository (https://hub.docker.com/repository/docker/omnileads/omlapp/general) whose
semantics implies the string RC (release candidates) or stable (able to deploy on production) string, before the dated version.

For example:

```
pre-release-1.27.0
1.27.0
```

On the other hand, the rest of the components (asterisk, rtpengine, kamailio, nginx, websockets and postgres) are
named directly with the release date.

For example:

```
230204.01
```

Every time a new Release of the application becomes available as an image in the container registry, it will be impacted.
the **Releases-Notes.md** file available in the root of this repository, which exposes the mapping between the
versions of the images of each component for each release.

Therefore to apply updates we must first launch on this repository:

```
git pull origin main
```

Then indicate at the inventory.yml level within the corresponding tenant folder, the versions
desired.

```
omnileads_version: 1.26.0
websockets_version: 230204.01
nginx_version: 230215.01
kamailio_version: 230204.01
asterisk_version: 230204.01
rtpengine_version: 230204.01
postgres_version: 230204.01
```

Then the deploy.sh script must be called with the --upgrade parameter.

```
./deploy.sh --action=upgrade --tenant=tenant_name_folder
```

## Rollback  :leftwards_arrow_with_hook: <a name="rollback"></a>


The use of containers when executing the OMniLeads components allows us to easily apply rollbacks towards versions
frozen history and accessible through the "tag".

```
omnileads_version: stable-190112.01
websockets_version: 190112.01
nginx_version: 190112.01
kamailio_version: 190112.01
asterisk_version: 190112.01
rtpengine_version: 190112.01
postgres_version: 190112.01
```

Then the deploy.sh script must be called with the --upgrade parameter.

```
./deploy.sh --action=upgrade --tenant=tenant_name_folder
```

## Restore :mag_right: <a name="restore"></a>


Se puede proceder con un restore tanto sobre una instalación fresca asi como también sobre una instancia productiva. 

Aplicar restore sobre la nueva instancia:Se debe descomentar los dos parametros finales del inventory.yml. Por un lado para indicar que el bucket no tiene certificados confiables y el segundo es para indicar el restore que queremos ejecutar.

```
restore_file_timestamp: 1681215859 
```

Ejecutar el deploy del restore:

```
./deploy.sh --action=restore --tenant=digitalocean_deb
```

Comprobar que todo se haya recuperado.


## Upgrade from CentOS-7 OMniLeads instance <a name="upgrade_from_centos7"></a>


Se debe desplegar una instancia de OMniLeads "all in three" asegurandose de que las variables del inventory.yml planteadas
a continuación deberán valer igual que sus homónimas en la instancia de CentOS 7 desde donde se desea migrar. 

* ami_user
* ami_password
* postgres_password
* postgres_database
* postgres_user
* dialer_user
* dialer_password

Sobre la instancia de OMniLeads 1.2X CentOS-7 ejecutar los siguientes comandos para generar un backup de postgres por un lado 
y luego subir al Bucket Object Storage de la nueva versión de OMniLeads las grabaciones, audios de telefonía, las personalizaciones 
(en caso de haberlas) de Asterisk _custom.conf & _override_conf y también el propio backup de Postgres. 

```
export NOMBRE_BACKUP: algun_nombre
pg_dump omnileads > /tmp/pgsql-backup-$NOMBRE_BACKUP.sql
export AWS_ACCESS_KEY_ID=uLZTnLB0aURXI6NB
export AWS_SECRET_ACCESS_KEY=VSlMrqEWS7aWtgrn7G2zs949W6jdFleY
export S3_ENDPOINT=https://172.16.101.3:9000
export S3_BUCKET_NAME=tenant1 # nombre del bucket del inventory.yml env 2.0
aws --endpoint ${S3_ENDPOINT} --no-verify-ssl s3 sync /opt/omnileads/media_root s3://${S3_BUCKET_NAME}/media_root
aws --endpoint ${S3_ENDPOINT} --no-verify-ssl s3 sync /opt/omnileads/asterisk/var/spool/asterisk/monitor/ s3://${S3_BUCKET_NAME}
aws --endpoint ${S3_ENDPOINT} --no-verify-ssl s3 cp /tmp/pgsql-backup-$NOMBRE_BACKUP.sql  s3://${S3_BUCKET_NAME}/backup/
mkdir /opt/omnileads/asterisk/etc/asterisk/custom
cd /opt/omnileads/asterisk/etc/asterisk
cp *_custom* ./custom
cp *_override* ./custom
aws --endpoint ${S3_ENDPOINT} --no-verify-ssl s3 sync /etc/asterisk/custom/ s3://${S3_BUCKET_NAME}/backup/asterisk/$NOMBRE_BACKUP/
```

A partir del hecho de contar con todo lo necesario para restituir el servicio sobre la nueva infraestructura en el Bucket de la misma, 
se puede proceder con el deploy de este proceso de restauración. 

Hacia el final del archivo se encuentra la variable *restore_file_timestamp* la cual debe contener el nombre nombre utilizado en
el paso anterior para referir a los backups tomados. 

```
restore_file_timestamp: NOMBRE_BACKUP
```

Ejecutar el deploy del restore sobre le tenant en cuestión:

```
./deploy.sh --action=restore --tenant=tenant1
```


## Observability :mag_right: <a name="observability"></a>


Inside each subscriber linux instance the deployer put some containers in order to implementar la observabilidad de todo el stack. Para no solo poder 
observar metricas a nivel sistema operativo sino que ademas poder obtener metricas especificas de componentes como redis, postgres o asterisk, así como
también levantar los logs del sistema operativo y de los componentes y enviarlos al stack de observabilidad. 

Esto nos permite plantear un centro de observabilidad multi instancias. Sobre el cual es posible centralizar el monitoreo de métricas
del OS y de la aplicación y sus componentes, así como también centralizar el análisis de logs.

Esto es posible gracias al planteo de Prometheus junto a sus exporters para el monitoreo de métricas por un lado 
mientras que Loki y Promtail implementan la centralización de los logs. 

* **Homer SIP Capture**: used to receive the SIP/RTP information sent to it by Asterisk (hep.conf). Homer stores this data and also provides a web interface to view real-time SIP traces.
* **Prometheus**: used to collect performance metrics from both the hosts (application / voice) and their components (asterisk, redis, postgres, etc.), also collects the metrics reported by SIP Homer Capture itself .
* **Loki**: used to storage file logs generated by OMniLeads components like django, nginx, kamailio, etc.
* **Promtail**: used to parse logs file on Linux VM nd send this to Loki DB.

![Diagrama deploy tool zoom](./png/observability_boxes.png)

Finally, you will be able to have an instance of Grafana and Prometheus that invoke this Prometheus deployed on tenat like data-source in order
to them build dashboards, on the other hand Grafana must to invoke the Loki deployed on tenant like data-source for logs analisys.

![Diagrama deploy tool zoom](./png/observability_MT.png)


## Seguridad

OMniLeads es una aplicación que conjuga las tecnologías Web, WebRTC y VoIP. Esto implica cierta complejidad y recaudos 
al momento de desplegar la misma en producción bajo un esquema de acceso directo a través de Internet. 

Lo ideal es que se utiliza un Proxy o Balanceador de carga expuesto a internet y que éste reenvíe las solicitudes 
al Nginx del stack de OMniLeads, así como también al momento de conectar con la PSTN a través de SIP/RTP resulta ideal 
operar detrás de un SBC expuesto a Internet.

En caso de operar en proveedores cloud que ofrecen VPS expuestos a Internet, se debe utilizar un Cloud Firewall para 
asegurar las instancias Linux (data, voz y web) que componen OMniLeads. A continuación se indican las reglas de Firewall
que deberán ser aplicadas sobre cada instancia.

### Data

* 3100/TCP Loki: por aqui se procesan las conexiones provenientes del centro de monitoreo, mas precisamente desde Grafana. Se puede 
abrir este puerto restringiendo por origen en la IP del centro de monitoreo.

### Voice

* 5060/UDP Asterisk: por aqui se procesan las solicitudes SIP de llamadas entrantes provenientes desde el o los ITSP. Se debe abrir este puerto restringiendo por origen en la IP o IPs de o los proveedores de terminación PSTN SIP.

* 20000/50000 UDO Asterisk & RTP engine: este rango de puertos se puede abrir a todo Internet.

### Web

* 443/tcp Nginx: por aquí se procesan las peticiones Web/WebRTC que llegan hacia Nginx. Se puede abrir el puerto 443 a todo Internet.

* 9190/tcp Prometheus: por aqui se procesan las conexiones provenientes del centro de monitoreo, mas precisamente desde Prometheus. Se puede abrir este  puerto restringiendo por origen en la IP del centro de monitoreo.

## License & Copyright

This project is released under the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
