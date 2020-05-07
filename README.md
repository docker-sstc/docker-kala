# docker-kala

Build from official release

## Usage

### BoltDB

> This is default db

```bash
docker run -d --name kala \
  -p 8000:8000 \
  -v /tmp/kala:/tmp \
  kala
```

```console
$ curl http://127.0.0.1:8000/api/v1/job/
{"jobs":{}}

$ ls -al /tmp/kala
.rw------- 32k root  6 May  0:22 jobdb.db
```

### MySQL

> localhost

```bash
docker run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_DATABASE=test mariadb:10
docker run -d --name kala \
  -p 8000:8000 \
  --link mysql \
  sstc/kala \
  kala run --jobDB=mariadb \
  --jobDBAddress="(mysql:3306)/test" \
  --jobDBUsername=root \
  --jobDBPassword=
```

> remote, GCP

```bash
docker run --rm --name kala \
  -p 8000:8000 \
  -v /host/secret:/path/to \
  sstc/kala \
  kala run --jobDB=mysql \
  --jobDBAddress="(93.184.216.34:3306)/kala?tls=custom" \
  --jobDBUsername="root" \
  --jobDBPassword="" \
  --jobDBTlsCAPath="/path/to/server-ca.pem" \
  --jobDBTlsCertPath="/path/to/client-cert.pem" \
  --jobDBTlsKeyPath="/path/to/client-key.pem" \
  --jobDBTlsServerName="<GCP Project ID>:<GCP SQL Instance ID>"
```

## Need to know

- Because of this image only pre-installed few necessary programs. If you wanted to execute others in container, for example python, you might want to build your own image:

  ```dockerfile
  FROM python:3-slim
  COPY --from=sstc/kala:scratch /usr/local/bin/kala /usr/local/bin/kala
  CMD ["kala", "run", "--jobDB=boltdb", "--boltpath=/tmp"]
  EXPOSE 8000
  ```
