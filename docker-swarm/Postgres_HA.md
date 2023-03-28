POST-INSTALL CONFIG
###################


###  PASO 1 - En nodo main hacer:

```
nodo01: su postgres -
nodo01: cd ~
nodo01: pg_basebackup -h ip_nodo_main -U replicador -p 5432 -D basebackup -Fp -Xs -P -R
nodo01: rsync -a basebackup/ root@ip_nodo_replica:/var/lib/pgsql/11/data/
```

 *password: el que seteo en el inventory (postgres_password)*

###  PASO 2 (opcional) - En nodo backup levantar pgsql y comprobar la replicación. Verificar que esté en modo SOLO LECTURA y luego volver a bajar el servicio:


- Crear base de datos y tabla de testing

```
nodo01: createdb test-ha;
nodo01: psql -d test-ha
nodo01: create table test (int serial);
nodo01: insert into test (select generate_series(1,1000));
nodo01: select count(*) from test;
```

- Comprobar en nodo 2, el INSERT tiene que fallar al estar en modo RO!

```
nodo02: systemctl start postgresql-11
nodo02: su postgres -
nodo02: cd ~
nodo02: psql -d test-ha
nodo02: select count(*) from test;
nodo02: insert into test (select generate_series(1,1000));
nodo02: systemctl stop postgresql-11
```

### PASO 3 - En el nodo main registrarlo como main del cluster:

```
nodo01: repmgr -f repmgr.conf master register -F
```

### PASO 4 - nodo backup: Asegurarnos que psgql esté abajo y comprobar que es posible generar clonar repmgr:

```
nodo02: systemctl stop postgresql-11
nodo02: su postgres -
nodo02: cd ~
nodo02: repmgr -h ip_nodo_main -U repmgr -d repmgr -f repmgr.conf standby clone --dry-run
```

Si todo va bien debería observarse una salida así:

```
INFO: executing:
  /usr/pgsql-11/bin/pg_basebackup -l "repmgr base backup"  -D /var/lib/pgsql/11/data -h 172.16.20.121 -p 5432 -U repmgr -X stream 
NOTICE: standby clone (using pg_basebackup) complete
NOTICE: you can now start your PostgreSQL server
HINT: for example: pg_ctl -D /var/lib/pgsql/11/data start
HINT: after starting the server, you need to register this standby with "repmgr standby register"
```

Entonces se avanza con:

```
nodo02: repmgr -h ip_nodo_main -U repmgr -d repmgr -f repmgr.conf standby clone -F
```

###  PASO 5 -Luego se levanta postgres y se registra el nodo como standby:

```
nodo02: systemctl start postgresql-11
nodo02: su postgres -
nodo02: cd ~
nodo02: repmgr -f repmgr.conf standby register -F
```

### PASO 6 - Restart de servicios postgresql y repmgr en AMBOS nodos

```
systemctl restart omlpgsql-ha 
systemctl restart repmgr11
```


### FAILOVER de nodo MAIN hacia REPLICA:


```
nodo01: systemctl stop postgresql-11
nodo02: se volverá activo (comprobar IPs)
```

### Pasos para realizar el RECOVER nodo MAIN:

```
nodo01: systemctl stop postgresql-11
nodo01: su postgres -
nodo01: cd ~
nodo01: repmgr -h ip_nodo_replica -U repmgr -d repmgr -f repmgr.conf standby clone --dry-run
nodo01: repmgr -h ip_nodo_replica -U repmgr -d repmgr -f repmgr.conf standby clone -F
nodo01: systemctl start postgresql-11
nodo01: repmgr -f repmgr.conf standby register -F
```

### Pasos para realizar TAKEOVER del servicio en el nodo MAIN:

```
nodo02: systemctl stop postgresql-11
nodo02: repmgr -h ip_nodo_main -U repmgr -d repmgr -f repmgr.conf standby clone --dry-run
nodo02: repmgr -h ip_nodo_main -U repmgr -d repmgr -f repmgr.conf standby clone -F
nodo02: systemctl start postgresql-11
nodo02: repmgr -f repmgr.conf standby register -F
```