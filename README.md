# docker-kala

Build from official release

## Tags

- [`sstc/kala:all`](https://github.com/up9cloud/docker-kala/blob/master/all/Dockerfile): latest + `python3`, `php`, `nodejs`, `ruby`, `lua5.3`
- [`sstc/kala:alpine`](https://github.com/up9cloud/docker-kala/blob/master/alpine/Dockerfile): alpine based with `bash`, `curl`, `rsync`, `openssh-client`, `bind-tools`
- [`sstc/kala:debian`](https://github.com/up9cloud/docker-kala/blob/master/Dockerfile): debian based with some basic stuff `curl`, `rsync`, `openssh-client`, `dnsutils`, `jq`
- [`sstc/kala:scratch`](https://github.com/up9cloud/docker-kala/blob/master/scratch/Dockerfile), `sstc/kala:latest`: only executable

## Usage

### Default with BoltDB

```bash
docker run -d --name kala \
  -p 8000:8000 \
  -v /tmp/kala:/tmp \
  sstc/kala
```

```console
$ curl http://127.0.0.1:8000/api/v1/job/
{"jobs":{}}

$ ls -al /tmp/kala
.rw------- 32k root  6 May  0:22 jobdb.db
```

### MySQL, MariaDB

> localhost

```bash
docker run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_DATABASE=test mariadb:10
docker run -d --name kala \
  -p 8000:8000 \
  --link mysql \
  sstc/kala \
  kala serve \
  --jobdb=mariadb \
  --jobdb-address="(mysql:3306)/test" \
  --jobdb-username=root \
  --jobdb-password=
```

> remote, GCP

```bash
docker run --rm --name kala \
  -p 8000:8000 \
  -v /host/secret:/path/to \
  sstc/kala \
  kala serve \
  --jobdb=mysql \
  --jobdb-address="(8.8.4.4:3306)/kala?tls=custom" \
  --jobdb-username="root" \
  --jobdb-password="" \
  --jobdb-tls-capath="/path/to/server-ca.pem" \
  --jobdb-tls-certpath="/path/to/client-cert.pem" \
  --jobdb-tls-keypath="/path/to/client-key.pem" \
  --jobdb-tls-servername="<GCP Project ID>:<GCP SQL Instance ID>"
```

## Need to know

- `Build by your own image`: because this image only has few pre-installed programs. If you want to execute others in the container, you might want to build your own, e.q. python:

  ```dockerfile
  FROM python:3-slim
  COPY --from=sstc/kala:scratch /usr/local/bin/kala /usr/local/bin/kala
  COPY --from=sstc/kala:scratch /app/webui /app/webui
  WORKDIR /app
  ...
  ```
