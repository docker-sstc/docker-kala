FROM golang as builder

ARG VERSION=0.8.4

WORKDIR /tmp
RUN set -ex; \
	wget -O src.tar.gz https://github.com/ajvb/kala/archive/v${VERSION}.tar.gz; \
	tar -xzf src.tar.gz; \
	mv kala-${VERSION} kala; \
	cd kala; \
	CGO_ENABLED=0 go build -o /tmp/main

FROM alpine:3.11
COPY --from=builder /tmp/main /usr/local/bin/kala
COPY --from=builder /tmp/kala/webui /app/webui
RUN apk add --no-cache \
	bash \
	curl \
	rsync \
	openssh-client \
	bind-tools \
	jq
WORKDIR /app
# change default db root path to /tmp, let user mount the volume easier
CMD ["kala", "serve", "--bolt-path=/tmp"]
EXPOSE 8000
