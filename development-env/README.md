# OMniLeads Docker Compose

Para levantar el entorno de desarrollo se deberá ejecutae por única vez el script de deploy.sh

```
$ ./deploy.sh --os_host= --gitlab_clone=
```




## Post raise up config:


```
./minio_bucket.sh
```


```
./manage.sh --reset_pass
```

## manage.sh script

This is used to launch some administration actions:

- reset django admin password
- drop all postgres databases
- drop all redis cache
