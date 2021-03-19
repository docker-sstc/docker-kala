FROM golang as builder

ARG VERSION=0.8.4

WORKDIR /tmp
RUN set -ex; \
	wget -O src.tar.gz https://github.com/ajvb/kala/archive/v${VERSION}.tar.gz; \
	tar -xzf src.tar.gz; \
	cd kala-${VERSION};\
	CGO_ENABLED=0 go build -o /tmp/main

FROM debian:stable-slim
COPY --from=builder /tmp/main /usr/local/bin/kala
RUN set -ex; \
	apt-get update; \
	DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	curl \
	rsync \
	openssh-client \
	dnsutils \
	jq \
	; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*
WORKDIR /app
# change default db root path to /tmp, let user mount the volume easier
CMD ["kala", "serve", "--jobdb=boltdb", "--boltpath=/tmp"]
EXPOSE 8000
