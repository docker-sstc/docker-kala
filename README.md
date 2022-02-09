# docker-kala

Build from [official release](https://github.com/ajvb/kala)

## Tags

- [`sstc/kala:all`](https://github.com/up9cloud/docker-kala/blob/master/all/Dockerfile):
  - `sstc/kala:debian` +
  - `python3`, `php`, `nodejs`, `ruby`, `lua5.3`
  - `chromium` + `node_modules/playwright-chromium` + `node_modules/puppeteer`
- [`sstc/kala:alpine`](https://github.com/up9cloud/docker-kala/blob/master/alpine/Dockerfile):
  - alpine based +
  - `bash`, `curl`, `rsync`, `openssh-client`, `bind-tools`
- [`sstc/kala:debian`](https://github.com/up9cloud/docker-kala/blob/master/Dockerfile):
  - debian based +
  - `curl`, `rsync`, `openssh-client`, `dnsutils`, `jq`
- [`sstc/kala:scratch`, `sstc/kala:latest`](https://github.com/up9cloud/docker-kala/blob/master/scratch/Dockerfile):
  - only kala executable

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

> GCP mysql with TLS

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

- `Build by your own image`: because this image only has few pre-installed programs. If you want to execute others in the container, you might want to build your own, e.q.

  ```dockerfile
  FROM sstc/kala:all
  RUN set -ex; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    julia \
    ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*
  ```

  ```bash
  docker build -t kala .
  docker run --rm kala julia -e 'println("hello world")'
  ```

## Dev memo

> Bump base image version

- Update version variables in file `./update.sh`
- Execute `./update.sh`

> Bump kala version

- Update version in file `Dockerfile-0-builder`
- Execute `./update.sh`
